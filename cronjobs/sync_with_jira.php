<?php
/**
 * File containing cronjob for jira sync
 *
 * @copyright Copyright (C) 2010 NXC AS. All rights reserved.
 * @license GNU GPL v2
 * @package nxc_resource_plan
 */

$cli->output( "Jira: Syncronyzing with jira process start" );
try
{
    nxcplanJiraHandler::sync();
}
catch ( Exception $error )
{
    $cli->error( $error->getMessage() );
}

$cli->output( "Jira: Syncronyzing with jira process end" );
?>
