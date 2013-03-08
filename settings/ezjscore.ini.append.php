<?php /* #?ini charset="utf-8"?

[ezjscServer]
FunctionList[]=nxcplan_storePlan
FunctionList[]=nxcplan_storeEmployee
FunctionList[]=nxcplan_fetchPlan
FunctionList[]=nxcplan_fetchEmployee
FunctionList[]=nxcplan_fetchPlanListByStartMonth
FunctionList[]=nxcplan_removePlan
FunctionList[]=nxcplan_disableEmployee
#FunctionList[]=ezstarrating_user_has_rated

[ezjscServer_nxcplanServer]
# Url to test this server function(rate):
# <root>/ezjscore/call/ezstarrating::rate::<contentobjectattribute_id>::<version>::<rating>
Class=nxcplanServerFunctions
Functions[]=nxcplan
PermissionPrFunction=enabled
File=extension/nxc_resource_plan/classes/nxcplanServerFunctions.php

*/ ?>