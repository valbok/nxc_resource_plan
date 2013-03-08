<?php
/**
 * File containing the nxcplanJiraHandler class.
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

/**
 * Jira handler for syncronization with jira server
 */
class nxcplanJiraHandler
{
    /**
     * Constructor
     */
    function __construct()
    {
    }

    /**
     * Checks error and throws excaption if any
     */
    protected static function checkError( $client, $result )
    {
        if ( $client->fault )
        {
	        throw new Exception( 'Fault: ' . print_r( $result, true ) );
        }

	
        $err = $client->getError();
        if ( $err )
        {
            throw new Exception( 'SOAP:Error: ' . $err );
        }
    }

    /**
     * Fetches project list from server
     */
    protected static function fetchProjectList( $client, $token )
    {
        $result = $client->call( 'getProjectsNoSchemes', array( $token ) );
        self::checkError( $client, $result );

        return $result;
    }

    /**
     * Fetches user list from server
     */
    protected static function fetchUserList( $client, $token )
    {
        $result = $client->call( 'getGroup', array( $token, 'developers' ) );
        self::checkError( $client, $result );

        return $result;
    }

    /**
     * Main function to sync with jira data
     */
    public static function sync()
    {
        $ini = eZINI::instance( 'jira.ini' );
        $server = $ini->hasVariable( 'JiraSettings', 'WsdlServer' ) ? $ini->variable( 'JiraSettings', 'WsdlServer' ) : false;

        if ( !$server )
        {
            throw new Exception( 'jira.ini[JiraSettings]:WsdlServer is not defined' );
        }

        $user = $ini->hasVariable( 'JiraSettings', 'User' ) ? $ini->variable( 'JiraSettings', 'User' ) : false;
        $password = $ini->hasVariable( 'JiraSettings', 'Password' ) ? $ini->variable( 'JiraSettings', 'Password' ) : false;

        if ( !$user )
        {
            throw new Exception( 'jira.ini[JiraSettings]:User is not defined' );
        }

        if ( !$password )
        {
            throw new Exception( 'jira.ini[JiraSettings]:Password is not defined' );
        }

        $credentials = array( $user, $password );

        $client = new nusoap_client( $server, 'wsdl' );

        // Login to JIRA
        $token = $client->call( 'login', $credentials );

        $db = eZDB::instance();
        $db->begin();

        $employeeList = self::fetchUserList( $client, $token );

        foreach ( $employeeList['users'] as $jiraEmployee )
        {
            $employee = nxcplanEmployee::fetchByName( utf8_encode( $jiraEmployee['name'] ) );
            if ( !$employee )
            {
                $employee = new nxcplanEmployee();
                // Init by unknown department
                $employee->setAttribute( 'department_id', 1 );
                $employee->setAttribute( 'is_enabled', 1 );
            }

            $employee->setAttribute( 'name', utf8_encode ( $jiraEmployee['name'] ) );
            $employee->setAttribute( 'full_name', utf8_encode( $jiraEmployee['fullname'] ) );
            $employee->store();
        }

        $projectList = self::fetchProjectList( $client, $token );

        foreach ( $projectList as $jiraProject )
        {
            $project = nxcplanProject::fetchByKey( $jiraProject['key'] );
            if ( !$project )
            {
                $project = new nxcplanProject();
                $project->setAttribute( 'jira_key', $jiraProject['key'] );
            }

            $project->setAttribute( 'name', utf8_encode( $jiraProject['name'] ) );
            $project->setAttribute( 'lead', utf8_encode( $jiraProject['lead'] ) );
            $project->setAttribute( 'url', $jiraProject['url'] );
            $project->setAttribute( 'description', utf8_encode( $jiraProject['description'] ) );
            $project->store();
        }

        $db->commit();
    }
}

?>
