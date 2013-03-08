<?php
/**
 * File containing the nxcplanProjectPlan class.
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

/**
 * Project plan
 */
class nxcplanProjectPlan extends eZPersistentObject
{
    const StatusPending = 0;
    const StatusApproved = 1;
    const StatusDenied = 2;

    /**
     * Constructor
     */
    function __construct( $row )
    {
        $this->eZPersistentObject( $row );
    }

    /**
     * Returns status list
     */
    public static function getStatusList()
    {
        return array( self::StatusPending => 'Pending',
                      self::StatusApproved => 'Approved',
                      self::StatusDenied => 'Denied' );
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
                                         'project_id' => array( 'name' => 'ProjectID',
                                                                'datatype' => 'integer',
                                                                'default' => 0,
                                                                'required' => true ),
                                         'employee_id' => array( 'name' => 'EmployeeID',
                                                                 'datatype' => 'integer',
                                                                 'default' => 0,
                                                                'required' => true ),
                                         'comment' => array( 'name' => 'Comment',
                                                             'datatype' => 'string',
                                                             'default' => '',
                                                             'required' => false ),
                                         'start_week' => array( 'name' => 'StartWeek',
                                                                'datatype' => 'integer',
                                                                'default' => '0',
                                                                'required' => true ),
                                         'end_week' => array( 'name' => 'EndWeek',
                                                              'datatype' => 'integer',
                                                              'default' => '0',
                                                              'required' => true ),
                                         'year' => array( 'name' => 'Year',
                                                              'datatype' => 'integer',
                                                              'default' => '0',
                                                              'required' => true ),
                                         'eah' => array( 'name' => 'EAH',
                                                              'datatype' => 'integer',
                                                              'default' => '0',
                                                              'required' => true ),
                                         'has_sow' => array( 'name' => 'HasSow',
                                                             'datatype' => 'integer',
                                                             'default' => '0',
                                                             'required' => true ),
                                         'status' => array( 'name' => 'Status',
                                                            'datatype' => 'integer',
                                                            'default' => '0',
                                                            'required' => true ),
                                         ),
                      "keys" => array( 'id' ),
                      "function_attributes" => array( 'project' => 'project',
                                                      'employee' => 'employee',
                                                      'status_name' => 'status_name',
                                                      'percent_load' => 'getPercentLoad' ),
                      "increment_key" => 'id',
                      "class_name" => 'nxcplanProjectPlan',
                      "sort" => array( "id" => "asc" ),
                      "name" => "nxcplan_projectplan" );
    }

    /**
     * Fetches current object
     */
    public static function fetch( $id, $asObject = true )
    {
        return eZPersistentObject::fetchObject( nxcplanProjectPlan::definition(),
                                                null,
                                                array( 'id' => $id ),
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
            case 'project':
            {
                $retVal = nxcplanProject::fetch( $this->attribute( 'project_id' ) );
            } break;

            case 'employee':
            {
                $retVal = nxcplanEmployee::fetch( $this->attribute( 'employee_id' ) );
            } break;

            case 'status_name':
            {
                $statusList = self::getStatusList();
                $retVal = $statusList[$this->attribute( 'status' )];
            } break;

            default:
            {
                $retVal = eZPersistentObject::attribute( $attr );
            } break;
        }

        return $retVal;
    }

    /**
     * Validates user input
     *
     * @return true if ok or string with error
     */
    public function validate( $isUpdate = true )
    {
        $projectId = $this->attribute( 'project_id' );
        $employeeId = $this->attribute( 'employee_id' );
        $startWeek = (int) $this->attribute( 'start_week' );
        $endWeek = (int) $this->attribute( 'end_week' );
        $year = (int) $this->attribute( 'year' );
        $eah = $this->attribute( 'eah' );
        $status = $this->attribute( 'status' );
        $statusList = self::getStatusList();

        if ( !$projectId )
        {
            return 'Project id is required' . $projectId;
        }

        if ( !$employeeId )
        {
            return 'Employee id is required';
        }

        if ( !$startWeek )
        {
            return 'Start week is required and cannot be 0';
        }

        if ( !$endWeek )
        {
            return 'End week is required and cannot be 0';
        }

        if ( $startWeek > $endWeek )
        {
            return 'Start week cannot be more than end week';
        }

        if ( $startWeek < 0 )
        {
            return 'Start week cannot be less than zero';
        }

        if ( $endWeek > 53 )
        {
            return 'End week cannot be more than 53';
        }

        if ( !$eah )
        {
            return 'Amount of hours is required and cannot be 0';
        }

        if ( $eah < 0 )
        {
            return 'Amount of hours cannot be less than 0';
        }

        if ( !isset( $statusList[$status] ) )
        {
            return 'Status is incorrect';
        }

        for ( $i = $startWeek; $i <= $endWeek; $i++ )
        {
            $list = self::fetchListByWeek( $i, $year, $employeeId );
            foreach ( $list as $plan )
            {
                if ( $this->attribute( 'id' ) != $plan->attribute( 'id' ) and $projectId == $plan->attribute( 'project_id' ) )
                {
                    return "User '" . $this->attribute( 'employee' )->attribute( 'name' ) . "' already has time for project '" . $plan->attribute( 'project' )->attribute( 'name' ) . "' (weeks: " . $plan->attribute( 'start_week' ) . "-" . $plan->attribute( 'end_week' ) . ')';
                }
            }
        }

        return true;

    }

    /**
     * Fetches list by week. That should be between start and end week
     */
    public static function fetchListByWeek( $week,
                                            $year = false,
                                            $employeeId = false,
                                            $offset = false,
                                            $limit = false,
                                            $asObject = true )
    {
        $db = eZDB::instance();
        $cond = array( 'start_week' => array( '<=', $week ),
                       'end_week' => array( '>=', $week ),
                       'year' => $year );

        if ( $employeeId )
        {
            $cond['employee_id'] = $employeeId;
        }

        return eZPersistentObject::fetchObjectList( nxcplanProjectPlan::definition(),
                                                    null,
                                                    $cond,
                                                    array( 'id' => 'asc' ),
                                                    null,
                                                    $asObject );
    }

    /**
     * Fetches list by week list.
     */
    public static function fetchListByWeekList( $weekArray,
                                                $year = false,
                                                $employeeId = false,
                                                $offset = false,
                                                $limit = false,
                                                $asObject = true )
    {
        $weekList = implode( ',' , $weekArray );

        $def = self::definition();
        $projectDef = nxcplanProject::definition();
        $employeeDef = nxcplanEmployee::definition();

        $customFields = array();
        foreach ( $def['fields'] as $name => $value )
        {
            $customFields[] = $def['name'] . '.' . $name;
        }

        $customTables = array( $projectDef['name'], $employeeDef['name'] );
        $customConds = '';
        $cond = array();
        if ( $employeeId )
        {
            $cond['employee_id'] = $employeeId;
        }
        else
        {
            $customConds = ' WHERE ';
        }

        $customConds .=  $def['name'] . '.project_id = ' . $projectDef['name'] . '.id
                         AND ' . $def['name'] . '.employee_id = ' . $employeeDef['name'] . '.id
                         AND '. $employeeDef['name'] . '.is_enabled = 1
                         AND ( start_week in (' . $weekList . ') or end_week in (' . $weekList . ') )';
        if ( $year )
        {
            $customConds .= ' AND year = ' . $year;
        }

        return eZPersistentObject::fetchObjectList( nxcplanProjectPlan::definition(),
                                                    array(),
                                                    $cond,
                                                    array( $projectDef['name'] . '.name' => 'asc',
                                                           $employeeDef['name']. '.name' => 'asc' ),
                                                    null,
                                                    $asObject,
                                                    null, // grouping
                                                    $customFields,
                                                    $customTables,
                                                    $customConds
                                                    );
    }


    /**
     * Returns whole week list by month
     */
    public static function getWeekListByMonth( $month, $year = false )
    {
        $month = !$month ? date( 'n' ) : ( $month < 1 ? 1 : ( $month > 12 ? 12 : $month ) );
        if ( !$year )
        {
            $year = date( 'Y' );
        }

        $startTime = mktime( 0, 0, 0, $month, 1, $year );
        $startWeek = $month != 1 ? date( 'W', $startTime ) : 1;

        $weekList = array();
        $week = $startWeek;
        $j = 0;
        while ( $month == date( 'n', strtotime( '+' . $j++ . ' week', $startTime ) ) )
        {
            $weekList[] = (int) $week;
            $week++;
        }

        return $weekList;
    }

    /**
     * Fetches list by month
     */
    public static function fetchListByMonth( $startMonth = false, $year = false )
    {
        $weekList = self::getWeekListByMonth( $startMonth, $year );

        $list = nxcplanProjectPlan::fetchListByWeekList( $weekList, $year );
        foreach ( $list as $plan )
        {
            $result[$plan->attribute( 'id' )] = $plan;
        }

        return $result;
    }

    /**
     * Returns response for site
     */
    public function getAjaxResponse()
    {
        return array( 'id' => $this->attribute( 'id' ),
                      'project' => array( 'id' => $this->attribute( 'project' )->attribute( 'id' ),
                                          'url' => $this->attribute( 'project' )->attribute( 'url' ),
                                          'name' => $this->attribute( 'project' )->attribute( 'name' ),
                                          'lead' => array( 'name' => $this->attribute( 'project' )->attribute( 'lead' ),
                                                           'url' => nxcplanEmployee::getEmployeeJiraUrl( $this->attribute( 'project' )->attribute( 'lead' ) ) ),
                                          'description' => $this->attribute( 'project' )->attribute( 'description' ) ),
                      'employee' => array( 'id' => $this->attribute( 'employee' )->attribute( 'id' ),
                                           'url' => $this->attribute( 'employee' )->attribute( 'url' ),
                                           'name' => $this->attribute( 'employee' )->attribute( 'name' ),
                                           'full_name' => $this->attribute( 'employee' )->attribute( 'full_name' ) ),
                      'comment' => $this->attribute( 'comment' ),
                      'start_week' => $this->attribute( 'start_week' ),
                      'end_week' => $this->attribute( 'end_week' ),
                      'year' => $this->attribute( 'year' ),
                      'percent_load' => $this->attribute( 'percent_load' ),
                      'eah' => $this->attribute( 'eah' ),
                      'has_sow' => $this->attribute( 'has_sow' ),
                      'status' => array( 'id' => $this->attribute( 'status' ),
                                         'name' => $this->attribute( 'status_name' ) )
                    );
    }

    /**
     * Calculates percent load per week
     */
    public function getPercentLoad()
    {
        return round( $this->attribute( 'eah' ) / ( ( $this->attribute( 'end_week' ) - $this->attribute( 'start_week' ) + 1 ) * 40 ) * 100 );
    }

    /**
     * Fetches total percent load by each week
     */
    public static function fetchWeekListByEmployee( $employeeId, $week, $year )
    {
        $list = self::fetchListByWeek( $week, $year, $employeeId );
        $result = array();
        $planList = array();
        $percent = 0;
        foreach ( $list as $plan )
        {
            $percent += $plan->getPercentLoad();
            $planList[] = $plan ;
        }

        $result['percent_load'] = $percent;
        $result['plan_list'] = $planList;

        return $result;
    }


    /**
     * Removes by employee id
     */
    public static function removeByEmployee( $employeeId )
    {
        $list = eZPersistentObject::fetchObjectList( nxcplanProjectPlan::definition(),
                                                     null,
                                                     array( 'employee_id' => $employeeId ),
                                                     null,
                                                     null,
                                                     $asObject );
        foreach ( $list as $object )
        {
            $object->remove();
        }
    }
}

?>

