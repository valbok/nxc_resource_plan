<?php
/**
 * File containing the nxcplanFunctionCollection class.
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

/**
 * Container for tpl fetch functions
 */
class nxcplanFunctionCollection
{
    /**
     * Constructor
     */
    function __construct()
    {
    }

    /**
     * Fetches project list
     */
    public static function fetchProjectList()
    {
        $list = nxcplanProject::fetchList();

        if ( !$list )
        {
            return array( 'error' => array( 'error_type' => 'kernel',
                                            'error_code' => eZError::KERNEL_NOT_FOUND ) );
        }

        $result = array( 'result' => $list );

        return $result;
    }

    /**
     * Fetches employee list
     */
    public static function fetchEmployeeList()
    {
        $list = nxcplanEmployee::fetchList();

        if ( !$list )
        {
            return array( 'error' => array( 'error_type' => 'kernel',
                                            'error_code' => eZError::KERNEL_NOT_FOUND ) );
        }

        $result = array( 'result' => $list );

        return $result;
    }

    /**
     * Fetche status list
     */
    public static function fetchPlanStatusList()
    {
        $list = nxcplanProjectPlan::getStatusList();

        if ( !$list )
        {
            return array( 'error' => array( 'error_type' => 'kernel',
                                            'error_code' => eZError::KERNEL_NOT_FOUND ) );
        }

        $result = array( 'result' => $list );

        return $result;
    }

    /**
     * Fetches week list
     */
    public static function fetchWeekListByEmployee( $employeeId, $week, $year )
    {
        $list = nxcplanProjectPlan::fetchWeekListByEmployee( $employeeId, $week, $year );

        $result = array( 'result' => $list );

        return $result;
    }

}

?>
