<?php
/**
 * File containing the nxcplanEmployee class.
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

/**
 * Employee
 */
class nxcplanEmployee extends eZPersistentObject
{
    /**
     * Constructor
     */
    function __construct( $row )
    {
        $this->eZPersistentObject( $row );
    }

    /**
     * DB definition
     */
    public static function definition()
    {
        return array( 'fields' => array( 'id' => array( 'name' => 'ID',
                                                        'datatype' => 'integer',
                                                        'default' => 0,
                                                        'required' => true ),
                                         'name' => array( 'name' => 'Name',
                                                          'datatype' => 'string',
                                                          'default' => '',
                                                          'required' => true ),
                                         'full_name' => array( 'name' => 'FullName',
                                                          'datatype' => 'string',
                                                          'default' => '',
                                                          'required' => false ),
                                         'department_id' => array( 'name' => 'DepartmentID',
                                                                   'datatype' => 'integer',
                                                                   'default' => 0,
                                                                   'required' => true ),
                                         'is_enabled' => array( 'name' => 'IsEnabled',
                                                                'datatype' => 'integer',
                                                                'default' => 1,
                                                                'required' => true ),
                                         ),
                      "keys" => array( 'id' ),
                      "function_attributes" => array( 'department' => 'department', 'url' => 'url' ),
                      "increment_key" => "id",
                      "class_name" => 'nxcplanEmployee',
                      "sort" => array( "name" => "asc" ),
                      "name" => "nxcplan_employee" );
    }

    /**
     * Fetches object
     */
    public static function fetch( $id, $asObject = true )
    {
        return eZPersistentObject::fetchObject( nxcplanEmployee::definition(),
                                                null,
                                                array( 'id' => $id ),
                                                $asObject );
    }

    /**
     * Removes from database
     */
    public function remove( $conditions = null, $extraConditions = null )
    {
        nxcplanProjectPlan::removeByEmployee( $this->attribute( 'id' ) );
        parent::remove();
    }

    /**
     * Fetches by name
     */
    public static function fetchByName( $name, $asObject = true )
    {
        return eZPersistentObject::fetchObject( nxcplanEmployee::definition(),
                                                null,
                                                array( 'name' => $name ),
                                                $asObject );
    }

    /**
     * Returns jira url
     */
    public static function getEmployeeJiraUrl( $name )
    {
        return 'http://nxcgroup.jira.com/secure/ViewProfile.jspa?name=' . $name;
    }

    /**
     * @reimp
     */
    public function attribute( $attr, $noFunction = false )
    {
        $retVal = null;
        switch( $attr )
        {
            case 'url':
            {
                $retVal = self::getEmployeeJiraUrl( $this->attribute( 'name' ) );
            } break;

            case 'department':
            {
                $retVal = nxcplanDepartment::fetch( $this->attribute( 'department_id' ) );
            } break;

            default:
            {
                $retVal = eZPersistentObject::attribute( $attr );
            } break;
        }

        return $retVal;
    }

    /**
     * Fetches list
     */
    public static function fetchList( $offset = false,
                                      $limit = false,
                                      $asObject = true )
    {
        $def = self::definition();
        $departmentDef = nxcplanDepartment::definition();

        $customFields = array();
        foreach ( $def['fields'] as $name => $value )
        {
            $customFields[] = $def['name'] . '.' . $name;
        }

        $customTables = array( $departmentDef['name'] );
        $customConds = ' WHERE ' . $def['name'] . '.department_id = ' . $departmentDef['name'] . '.id
                           AND ' . $def['name'] . '.is_enabled = 1';

        return eZPersistentObject::fetchObjectList( nxcplanEmployee::definition(),
                                                    array(),
                                                    null, // cond
                                                    array( $departmentDef['name'] . '.name' => 'asc',
                                                           $def['name'] . '.name' => 'asc' ),
                                                    array( 'limit' => $limit,
                                                           'offset' => $offset ),
                                                    $asObject,
                                                    null, // grouping
                                                    $customFields,
                                                    $customTables,
                                                    $customConds
                                                    );
    }

    /**
     * Fetches list by department id
     */
    public static function fetchListByDepartment( $departmentId,
                                     $offset = false,
                                      $limit = false,
                                      $asObject = true )
    {
        return eZPersistentObject::fetchObjectList( nxcplanEmployee::definition(),
                                                    null,
                                                    array( 'department_id' => $departmentId ),
                                                    null,
                                                    array( 'limit' => $limit,
                                                           'offset' => $offset ),
                                                    $asObject );
    }

    /**
     * Returns response for site
     */
    public function getAjaxResponse()
    {
        return array( 'id' => $this->attribute( 'id' ),
                      'department' => array( 'id' => $this->attribute( 'department' )->attribute( 'id' ),
                                             'name' => $this->attribute( 'department' )->attribute( 'name' ) )  );
    }
}

?>
