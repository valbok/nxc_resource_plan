<?php
/**
 * File containing the nxcplanServerFunctions class.
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

/**
 * Container for server functions
 */
class nxcplanServerFunctions extends ezjscServerFunctions
{
    /**
     * Stores plan
     *
     * @param array $args ( 0 => id,  1 => project_id, 2 => employee_id, 3 => comment, 4 => start_week, 5 => end_week, 6 => year, 7 => eah, 8 => has_sow, 9 => status )
     * @return array
     */
    public static function storePlan( $args )
    {
        // @TODO Check the rights
        $id = isset( $args[0] ) ? $args[0] : false;
        if ( !$id )
        {
            return array( 'error' => 'Id is required' );
        }

        $plan = ( strpos( $id, 'new_' ) === false ) ? nxcplanProjectPlan::fetch( $id ) : new nxcplanProjectPlan();;
        if ( !$plan )
        {
            return array( 'id' => $id,
                          'error' => "Could not fetch project plan object by id '$id'" );
        }

        if ( isset( $args[1] ) and $args[1] )
        {
            $plan->setAttribute( 'project_id', (int) $args[1] );
        }

        if ( isset( $args[2] ) and $args[2] )
        {
            $plan->setAttribute( 'employee_id', (int) $args[2] );
        }

        if ( isset( $args[3] ) and $args[3] )
        {
            $plan->setAttribute( 'comment', $args[3] );
        }

        if ( isset( $args[4] ) and $args[4] )
        {
            $plan->setAttribute( 'start_week', (int) $args[4] );
        }

        if ( isset( $args[5] ) and $args[5] )
        {
            $plan->setAttribute( 'end_week', (int) $args[5] );
        }

        if ( isset( $args[6] ) and $args[6] )
        {
            $plan->setAttribute( 'year', (int) $args[6] );
        }

        if ( isset( $args[7] ) and $args[7] )
        {
            $plan->setAttribute( 'eah', (int) $args[7] );
        }

        if ( isset( $args[8] ) )
        {
            $plan->setAttribute( 'has_sow', $args[8] == 1 ? 1 : 0 );
        }

        if ( isset( $args[9] ) )
        {
            $plan->setAttribute( 'status', $args[9] );
        }

        $resultArray = array();
        $result = $plan->validate();
        if ( $result === true )
        {
            $plan->store();
        }
        else
        {
            $resultArray['error'] = $result;
        }

        $resultArray['old_id'] = $id;
        $resultArray['id'] = $plan->attribute( 'id' );

        return $resultArray;
    }

    /**
     * Fetches project plan
     *
     * @param array $args ( 0 => id,  1 => old_id (tmp name) )
     * @return array
     */
    public static function fetchPlan( $args )
    {
        $id = isset( $args[0] ) ? $args[0] : false;
        if ( !$id )
        {
            return array( 'error' => "Id is required" );
        }

        $oldId = isset( $args[1] ) ? $args[1] : false;

        $plan = nxcplanProjectPlan::fetch( $id );
        if ( !$plan )
        {
            return array( 'error' => "Could not fetch project plan object by id '$id'",
                          'id' => $id );
        }

        $result = $plan->getAjaxResponse();

        if ( $oldId )
        {
            $result['old_id'] = $oldId;
        }

        return $result;
    }


    /**
     * Removes project plan
     *
     * @param array $args ( 0 => id )
     * @return array
     */
    public static function removePlan( $args )
    {
        // @TODO Check the rights
        $id = isset( $args[0] ) ? $args[0] : false;
        if ( !$id )
        {
            return array( 'error' => "Id is required" );
        }

        $plan = nxcplanProjectPlan::fetch( $id );
        if ( !$plan )
        {
            return array( 'error' => "Could not fetch project plan object by id '$id'",
                          'id' => $id );
        }

        $db = eZDB::instance();
        $db->begin();
        $plan->remove();
        $db->commit();

        return array( 'id' => $id );
    }


    /**
     * Fetches project plan list by month
     *
     * @param array $args ( 0 => month, 1 => $year )
     * @return array
     */
    public static function fetchPlanListByStartMonth( $args )
    {
        $startMonth = isset( $args[0] ) ? $args[0] : false;
        $year = isset( $args[1] ) ? $args[1] : false;
        if ( !$year )
        {
            return array( 'error' => "Year is required for fetchPlanListByStartMonth",
                          'id' => $id );
        }

        $planList = nxcplanProjectPlan::fetchListByMonth( $startMonth, $year );

        if ( $planList === false )
        {
            return array( 'error' => "Could not fetch project plan list object by start_week '$startWeek' and year '$year'" );
        }

        $result = array();
        foreach ( $planList as $plan )
        {
            $result[] = $plan->getAjaxResponse();
        }

        return $result;
    }


    /**
     * Stores employee
     *
     * @param array $args ( 0 => id,  1 => department_id )
     * @return array
     */
    public static function storeEmployee( $args )
    {
        // @TODO Check the rights
        $id = isset( $args[0] ) ? $args[0] : false;
        if ( !$id )
        {
            return array( 'error' => 'Id is required' );
        }

        $user = nxcplanEmployee::fetch( $id );
        if ( !$user )
        {
            return array( 'id' => $id,
                          'error' => "Could not fetch employee object by id '$id'" );
        }

        if ( isset( $args[1] ) )
        {
            $user->setAttribute( 'department_id', (int) $args[1] );
        }

        $db = eZDB::instance();
        $db->begin();
        $user->store();
        $db->commit();

        return array( 'id' => $id );
    }


    /**
     * Fetches employee
     *
     * @param array $args ( 0 => id )
     * @return array
     */
    public static function fetchEmployee( $args )
    {
        $id = isset( $args[0] ) ? $args[0] : false;
        if ( !$id )
        {
            return array( 'error' => "Id is required" );
        }

        $user = nxcplanEmployee::fetch( $id );
        if ( !$user )
        {
            return array( 'error' => "Could not fetch employee object by id '$id'",
                          'id' => $id );
        }

        return $user->getAjaxResponse();
    }

    /**
     * Removes employee
     *
     * @param array $args ( 0 => id )
     * @return array
     */
    public static function disableEmployee( $args )
    {
        // @TODO Check the rights
        $id = isset( $args[0] ) ? $args[0] : false;
        if ( !$id )
        {
            return array( 'error' => "Id is required" );
        }

        $user = nxcplanEmployee::fetch( $id );
        if ( !$user )
        {
            return array( 'error' => "Could not fetch employee object by id '$id'",
                          'id' => $id );
        }

        $user->setAttribute( 'is_enabled', 0 );
        $user->store();

        return array( 'id' => $id );
    }
}

?>