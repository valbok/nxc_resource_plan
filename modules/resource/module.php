<?php
/**
 * File containing module definition
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

$Module = array( 'Name' => 'NXC Resource plan' );

$ViewList = array();

$ViewList['plan'] = array( 'script' => 'plan.php',
                           'functions' => array( 'user' ),
                           'default_navigation_part' => 'nxcplan_plan_navigationpart',
                           'params' => array()
                           );
$ViewList['projects'] = array( 'script' => 'projects.php',
                               'functions' => array( 'user' ),
                               'default_navigation_part' => 'nxcplan_projects_navigationpart',
                               'params' => array()
                               );
$FunctionList = array();
$FunctionList['user'] = array();
$FunctionList['admin'] = array();

?>