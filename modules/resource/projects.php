<?php
/**
 * File containing resource/project module.
 * Edit/Add/Remove percent load for week per user
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

include_once( 'kernel/common/template.php' );

$Module = $Params["Module"];
$userParameters = isset( $Params['UserParameters'] ) ? $Params['UserParameters'] : array();
$year = isset( $userParameters['year'] ) ? $userParameters['year'] : date( 'Y' );
$startMonth = isset( $userParameters['start_month'] ) ? $userParameters['start_month'] : date( 'n' );
$startMonth = $startMonth < 1 ? 1 : ( $startMonth > 12 ? 12 : $startMonth );

$currentMonth = date( 'F', mktime( 0, 0, 0, $startMonth, 1, $year ) );
$previousMonth = date( 'F', mktime( 0, 0, 0, $startMonth - 1 , 1, $year ) );
$nextMonth = date( 'F', mktime( 0, 0, 0, $startMonth + 1, 1, $year ) );

$tpl = templateInit();

$tpl->setVariable( 'start_month', $startMonth );
$tpl->setVariable( 'current_month', $currentMonth );
$tpl->setVariable( 'previous_month', $previousMonth );
$tpl->setVariable( 'next_month', $nextMonth );
$tpl->setVariable( 'year', $year );

$Result = array();
$Result['content'] = $tpl->fetch( 'design:projects.tpl' );
$Result['path'] = array( array( 'url' => 'resource/projects',
                                'text' => "Projects" ) );
?>