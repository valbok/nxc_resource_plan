<?php
/**
 * File containing the nxcplanProject class.
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

/**
 * Project
 */
class nxcplanProject extends eZPersistentObject
{
    /**
     * Constructor
     */
    public function __construct( $row )
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
                                         'lead' => array( 'name' => 'Lead',
                                                                    'datatype' => 'string',
                                                                    'default' => '',
                                                                    'required' => true ),
                                         'jira_key' => array( 'name' => 'Key',
                                                          'datatype' => 'string',
                                                          'default' => '',
                                                          'required' => true ),
                                         'url' => array( 'name' => 'Url',
                                                          'datatype' => 'string',
                                                          'default' => '',
                                                          'required' => true ),
                                         'description' => array( 'name' => 'Description',
                                                          'datatype' => 'string',
                                                          'default' => '',
                                                          'required' => false ),
                                         ),
                      "keys" => array( 'id' ),
                      "function_attributes" => array(),
                      "increment_key" => "id",
                      "class_name" => 'nxcplanProject',
                      "sort" => array( "name" => "asc" ),
                      "name" => "nxcplan_project" );
    }

    /**
     * Fetches object
     */
    public static function fetch( $id, $asObject = true )
    {
        return eZPersistentObject::fetchObject( nxcplanProject::definition(),
                                                null,
                                                array( 'id' => $id ),
                                                $asObject );
    }

    /**
     * Fetches by jira key
     */
    public static function fetchByKey( $key, $asObject = true )
    {
        return eZPersistentObject::fetchObject( nxcplanProject::definition(),
                                                null,
                                                array( 'jira_key' => $key ),
                                                $asObject );
    }


    /**
     * @reimp
     */
    public function attribute( $attr, $noFunction = false )
    {
        $retVal = null;
        switch( $attr )
        {
            default:
            {
                $retVal = eZPersistentObject::attribute( $attr );
            } break;
        }

        return $retVal;
    }


    /**
     * Fetch list
     */
    public static function fetchList( $offset = false,
                                      $limit = false,
                                      $asObject = true )
    {
        return eZPersistentObject::fetchObjectList( nxcplanProject::definition(),
                                                    null,
                                                    null,
                                                    array( 'name' => 'asc' ),
                                                    array( 'limit' => $limit,
                                                           'offset' => $offset ),
                                                    $asObject );
    }
}

?>
