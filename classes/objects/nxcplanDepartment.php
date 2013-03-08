<?php
/**
 * File containing the nxcplanDepartment class.
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

/**
 * Department
 */
class nxcplanDepartment extends eZPersistentObject
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
                                         ),
                      "keys" => array( 'id' ),
                      "function_attributes" => array( ),
                      "increment_key" => "id",
                      "class_name" => 'nxcplanDepartment',
                      "sort" => array( "name" => "asc" ),
                      "name" => "nxcplan_department" );
    }

    /**
     * Fetches object
     */
    public static function fetch( $id, $asObject = true )
    {
        return eZPersistentObject::fetchObject( nxcplanDepartment::definition(),
                                                null,
                                                array( 'id' => $id ),
                                                $asObject );
    }

    /**
     * Fetches object list
     */
    public static function fetchList( $offset = false,
                                      $limit = false,
                                      $asObject = true )
    {
        return eZPersistentObject::fetchObjectList( nxcplanDepartment::definition(),
                                                    null,
                                                    null,
                                                    array( 'id' => 'asc' ),
                                                    array( 'limit' => $limit,
                                                           'offset' => $offset ),
                                                    $asObject );
    }
}

?>
