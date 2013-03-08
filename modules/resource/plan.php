<?php
/**
 * File containing module resource/plan.
 * Calendar of percent load per user
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

include_once( 'kernel/common/template.php' );

$Module = $Params["Module"];
$userParameters = isset( $Params['UserParameters'] ) ? $Params['UserParameters'] : array();
$userId = isset( $userParameters['user_id'] ) ? $userParameters['user_id'] : false;
$departmentId = isset( $userParameters['department_id'] ) ? $userParameters['department_id'] : false;
$year = isset( $userParameters['year'] ) ? $userParameters['year'] : date( 'Y' );
$startMonth = isset( $userParameters['start_month'] ) ? $userParameters['start_month'] : date( 'n' );
$startMonth = $startMonth < 1 ? 1 : ( $startMonth > 12 ? 12 : $startMonth );

$currentWeek = date( 'W' );
$currentYear = date( 'Y' );

$currentMonthName = date( 'F', mktime( 0, 0, 0, $startMonth, 1 ) );
$previousMonthName = date( 'F', mktime( 0, 0, 0, $startMonth - 1 , 1 ) );
$nextMonthName = date( 'F', mktime( 0, 0, 0, $startMonth + 1, 1 ) );

$resultMonthList = array();
$resultYearList = array();

$yearList = array( $year => array( $startMonth => $currentMonthName ) );

$numberOfNextMonth = date( 'n', strtotime( $nextMonthName ) );
$yearList[$numberOfNextMonth < $startMonth ? $year + 1 : $year][$numberOfNextMonth] = $nextMonthName;

$prevMonth = false;
foreach ( $yearList as $yearKey => $monthList )
{
    foreach ( $monthList as $monthNumber => $monthName )
    {
        $weekList = nxcplanProjectPlan::getWeekListByMonth( $monthNumber, $yearKey );

        foreach ( $weekList as $week )
        {
            if ( $prevMonth and isset( $resultYearList[$yearKey][$prevMonth][$week] ) )
            {
                continue;
            }

            $resultYearList[$yearKey][$monthName][$week] = array();
            $list = nxcplanProjectPlan::fetchListByWeek( $week, $yearKey );

            foreach ( $list as $plan )
            {
                $resultYearList[$yearKey][$monthName][$week][$plan->attribute( 'employee_id' )] = $plan;
            }
        }

        $prevMonth = $monthName;
    }
}

$employeeList = $userId ? array( nxcplanEmployee::fetch( $userId ) ) : ( $departmentId ? nxcplanEmployee::fetchListByDepartment( $departmentId ) : nxcplanEmployee::fetchList() );
$employeeList = !isset( $employeeList[0] ) ? array() : $employeeList;

$viewParameters = array( 'start_month' => $startMonth,
                         'year' => $year );
if ( $userId )
{
    $viewParameters['user_id'] = $userId;
}
elseif ( $departmentId )
{
    $viewParameters['department_id'] = $departmentId;
}

$departmentList = nxcplanDepartment::fetchList();

$http = eZHTTPTool::instance();
$tpl = templateInit();

$tpl->setVariable( 'start_month', $startMonth );
$tpl->setVariable( 'employee_list', $employeeList );
$tpl->setVariable( 'year_list', $resultYearList );
$tpl->setVariable( 'department_list', $departmentList );
$tpl->setVariable( 'current_week', $currentWeek );
$tpl->setVariable( 'current_month', $currentMonthName );
$tpl->setVariable( 'current_year', $currentYear );
$tpl->setVariable( 'previous_month', $previousMonthName );
$tpl->setVariable( 'next_month', $nextMonthName );
$tpl->setVariable( 'view_parameters', $viewParameters );
$tpl->setVariable( 'year', $year );

$Result = array();
$Result['content'] = $tpl->fetch( 'design:plan.tpl' );
$Result['path'] = array( array( 'url' => 'resource/plan',
                                'text' => "Resource plan") );
?>