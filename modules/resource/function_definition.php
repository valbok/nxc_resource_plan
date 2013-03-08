<?php
/**
 * File containing tpl function list
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */


$FunctionList = array();

$FunctionList['project_list'] = array( 'name' => 'project_list',
                                       'operation_types' => array( 'read' ),
                                       'call_method' => array( 'class' => 'nxcplanFunctionCollection',
                                                         'method' => 'fetchProjectList' ),
                                       'parameter_type' => 'standard',
                                       'parameters' => array() );
$FunctionList['employee_list'] = array( 'name' => 'project_list',
                                        'operation_types' => array( 'read' ),
                                        'call_method' => array( 'class' => 'nxcplanFunctionCollection',
                                                                'method' => 'fetchEmployeeList' ),
                                        'parameter_type' => 'standard',
                                        'parameters' => array() );

$FunctionList['plan_status_list'] = array( 'name' => 'plan_status_list',
                                           'operation_types' => array( 'read' ),
                                           'call_method' => array( 'class' => 'nxcplanFunctionCollection',
                                                                   'method' => 'fetchPlanStatusList' ),
                                           'parameter_type' => 'standard',
                                           'parameters' => array() );

$FunctionList['week_list'] = array( 'name' => 'week_lisst',
                                       'operation_types' => array( 'read' ),
                                       'call_method' => array( 'class' => 'nxcplanFunctionCollection',
                                                               'method' => 'fetchWeekListByEmployee' ),
                                           'parameter_type' => 'standard',
                                           'parameters' => array( array( 'name' => 'employee_id',
                                                                         'type' => 'integer',
                                                                         'default' => false,
                                                                         'reguired' => true ),
                                                                  array( 'name' => 'week',
                                                                         'type' => 'integer',
                                                                         'default' => false,
                                                                         'reguired' => true ),
                                                                  array( 'name' => 'year',
                                                                         'type' => 'integer',
                                                                         'default' => false,
                                                                         'reguired' => true ) ) );


?>
