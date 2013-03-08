{def $project_list = fetch( "resource", "project_list" )
     $employee_list = fetch( "resource", "employee_list" )
     $status_list = fetch( "resource", "plan_status_list" )}

{def $adminAccess = fetch( 'user', 'has_access_to', hash( 'module', 'resource', 'function', 'admin' ) )
     $jscoreAccess = fetch( 'user', 'has_access_to', hash( 'module', 'ezjscore', 'function', 'call' ))}

<div class="context-block">
    <div class="box-ml">
        <div class="box-mr">
            <div class="box-content">
                <table id="plan_list" cellspacing="0" class="list">
                <tbody>
                    <tr>
                        <th style="text-align: right; color: grey;" colspan="12">{$current_month} {$year}</th>
                    </tr>
                    <tr>
                        <th style="text-align: left" width="20%">Project name</th>
                        <th style="text-align: left" width="8%">Lead</th>
                        <th style="text-align: left">Employee</th>
                        <th style="text-align: left">Comment</th>
                        <th width="10px">Start week</th>
                        <th width="10px">End week</th>
                        <th width="10px">Amount of hours</th>
                        <th width="50px">Load</th>
                        <th width="10px">SOW</th>
                        <th width="100px">Status</th>
                        <th width="10px"></th>
                        <th width="5px"></th>
                    </tr>
                </tbody>
                </table>

                {if $jscoreAccess}
                    <div class="block">
                        <div class="right" style="text-align: right; padding-right: 5px">
                            <input class="button" type="submit" name="NewButton" value="New" title="New" onclick="insertRow([])"/>
                        </div>
                    </div>
                {/if}
                {include uri="design:navigator.tpl"
                         start_month=$start_month
                         year=$year
                         url="resource/projects"
                         view_parameters=array()}
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
<!--

/**********************/
/*  Control functions */
/**********************/

/**
 * Number of first month that should be displayed
 */
var StartMonth = "{$start_month}";

{literal}
window.onload = function() { fetchPlanList( StartMonth ); };

/**
 *
 */
function getYear()
{
{/literal}
    return '{$year}';
{literal}
}

/**
 * Fetches plan list by month
 */
function fetchPlanList( startMonth )
{
    jQuery.ez( "nxcplanServer::fetchPlanListByStartMonth::" + startMonth + "::" + getYear(), {}, fetchPlanList_callBack );
}

/**
 *
 */
function isAdminAccess()
{
{/literal}
    return '{$adminAccess}' == '1' ? true : false;
{literal}
}

/**
 * Callback for fetchPlanList
 */
function fetchPlanList_callBack( data )
{
    if ( !data )
    {
        alert( "Bad response from server" );
        return;
    }

    if ( data.content["error"] )
    {
        alert( data.content["error"] );
        return;
    }

    for ( var plan in data.content )
    {
        insertRow( data.content[plan], plan );
    }
}

function addHandleRowWhenHidden( oldPlanId, newPlanId )
{
    if ( !isAdminAccess() )
    {
        return;
    }

    var tr = document.getElementById( "tr_" + oldPlanId );
    if ( tr == undefined )
    {
        return;
    }

    if ( newPlanId == undefined )
    {
        newPlanId = oldPlanId;
    }

    tr.ondblclick = function()
    {
        var element = document.getElementById( "select_project_" + newPlanId );
        if ( element != undefined && element.style.display == "none" )
        {
            handleRow( newPlanId, [] );
        }
    };
}


/**
 * Inserts rows to table list
 */
function insertRow( plan, index )
{
    index = index == undefined ? 0 : index;
    trClass = index % 2 ? "bgdark" : "bglight";
    var table = document.getElementById( "plan_list" );
    var planId = plan["id"] ? plan["id"] : "new_" + Math.random();
    var tr = document.createElement( "tr" );
    tr.setAttribute( "class", trClass );
    table.appendChild( tr );

    tr.setAttribute( "id", "tr_" + planId );
    addHandleRowWhenHidden( planId );

    var isEmpty = !plan["project"];

    /**
     * Project
     */
    var td = document.createElement( "td" );
    td.style.textAlign = "left";
    tr.appendChild( td );

    var tag = document.createElement( "select" );
    tag.style.width = "100%";
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "select_project_" + planId );
{/literal}
{foreach $project_list as $project}
    var option = document.createElement( "option" );
    option.setAttribute( "id", {$project.id} );
    option.innerHTML = "{$project.name}";
    if ( plan["project"] != undefined )
    {ldelim}
        if ( "{$project.id}" == plan["project"]["id"] )
        {ldelim}
            option.selected = "selected";
        {rdelim}
    {rdelim}

    tag.appendChild( option );
{/foreach}
{literal}
    td.appendChild( tag );

    var tag = document.createElement( "a" );
    if ( isEmpty )
    {
        handleVisibility( tag );
    }

    tag.setAttribute( "id", "link_project_" + planId );
    tag.setAttribute( "href", plan["project"] != undefined ? plan["project"]["url"] : "#" );
    tag.setAttribute( "title", plan["project"] != undefined ? plan["project"]["description"] : "" );
    tag.innerHTML = plan["project"] != undefined ? plan["project"]["name"] : "";

    td.appendChild( tag );

    /**
     * Lead
     */
    var td = document.createElement( "td" );
    td.style.textAlign = "left";
    tr.appendChild( td );

    var tag = document.createElement( "a" );
    tag.setAttribute( "id", "link_lead_" + planId );
    tag.setAttribute( "href", plan["project"] != undefined ? plan["project"]["lead"]["url"] : "#" );
    tag.innerHTML = plan["project"] != undefined ? plan["project"]["lead"]["name"] : "";
    td.appendChild( tag );

    /**
     * Employee
     */
    var td = document.createElement( "td" );
    td.style.textAlign = "left";
    tr.appendChild( td );

    var tag = document.createElement( "select" );
    tag.style.width = "100%";
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "select_employee_" + planId );
{/literal}
{foreach $employee_list as $employee}
    var option = document.createElement( "option" );
    option.setAttribute( "id", {$employee.id} );
    option.innerHTML = "{$employee.name}";
    if ( plan["employee"] != undefined )
    {ldelim}
        if ( "{$employee.id}" == plan["employee"]["id"] )
        {ldelim}
            option.selected = "selected";
        {rdelim}
    {rdelim}
    tag.appendChild( option );
{/foreach}
{literal}
    td.appendChild( tag );

    var tag = document.createElement( "a" );
    if ( isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "link_employee_" + planId );
    tag.setAttribute( "href", plan["employee"] != undefined ? plan["employee"]["url"] : "#" );
    tag.setAttribute( "title", plan["employee"] != undefined ? plan["employee"]["full_name"] : "" );
    tag.innerHTML = plan["employee"] != undefined ? plan["employee"]["name"] : "";
    td.appendChild( tag );

    /**
     * Comment
     */
    var td = document.createElement( "td" );
    td.style.textAlign = "left";
    tr.appendChild( td );

    var tag = document.createElement( "input" );
    tag.style.width = "100%";
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "edit_comment_" + planId );
    tag.value = plan["comment"] != undefined ? plan["comment"] : "" ;
    td.appendChild( tag );
    initEnterClick( tag, planId );

    var tag = document.createElement( "div" );
    if ( isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "text_comment_" + planId );
    tag.innerHTML = plan["comment"] != undefined ? plan["comment"] : "" ;
        td.appendChild( tag );

    /**
     * Start week
     */
    var td = document.createElement( "td" );
    tr.appendChild( td );

    var tag = document.createElement( "input" );
    tag.style.width = "40%";
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "edit_start_week_" + planId );
    tag.value = plan["start_week"] != undefined ? plan["start_week"] : "" ;
    td.appendChild( tag );
    initEnterClick( tag, planId );

    var img = document.createElement( "img" );
{/literal}
    img.setAttribute( "id", "img_start_week_" + planId );
    img.setAttribute( "src", {"cal.gif"|ezimage} );
{literal}
    td.appendChild( img );
    if ( !isEmpty )
    {
        handleVisibility( img );
    }

    Calendar.setup({
        firstDay     : 1,              // first day of the week
        inputField   : "edit_start_week_" + planId,     // id of the input field
        button       : "img_start_week_" + planId ,  // trigger for the calendar (button ID)
        align        : "Tl",           // alignment (defaults to "Bl")
        singleClick  : false,
        useISO8601WeekNumbers : true,
        ifFormat     : "%W"      // our date only format
    });

    var tag = document.createElement( "div" );
    if ( isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "text_start_week_" + planId );
    tag.innerHTML = plan["start_week"] != undefined ? plan["start_week"] : "";
    td.appendChild( tag );

    /**
     * End week
     */
    var td = document.createElement( "td" );
    tr.appendChild( td );

    var tag = document.createElement( "input" );
    tag.style.width = "40%";
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "edit_end_week_" + planId );
    tag.value = plan["end_week"] != undefined ? plan["end_week"] : "" ;
    td.appendChild( tag );
    initEnterClick( tag, planId );

    var img = document.createElement( "img" );
{/literal}
    img.setAttribute( "id", "img_end_week_" + planId );
    img.setAttribute( "src", {"cal.gif"|ezimage} );
{literal}
    td.appendChild( img );
    if ( !isEmpty )
    {
        handleVisibility( img );
    }

    Calendar.setup({
        firstDay     : 1,              // first day of the week
        inputField   : "edit_end_week_" + planId,     // id of the input field
        button       : "img_end_week_" + planId ,  // trigger for the calendar (button ID)
        align        : "Tl",           // alignment (defaults to "Bl")
        singleClick  : false,
        useISO8601WeekNumbers : true,
        ifFormat     : "%W"      // our date only format
    });

    var tag = document.createElement( "div" );
    if ( isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "text_end_week_" + planId );
    tag.innerHTML = plan["end_week"] != undefined ? plan["end_week"] : "";
    td.appendChild( tag );

    /**
     * Amount of hours
     */
    var td = document.createElement( "td" );
    tr.appendChild( td );

    var tag = document.createElement( "input" );
    tag.style.width = "40%";
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "edit_eah_" + planId );
    tag.value = plan["eah"] ? plan["eah"] : "" ;
    td.appendChild( tag );
    initEnterClick( tag, planId );

    var tag = document.createElement( "div" );
    if ( isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "text_eah_" + planId );
    tag.innerHTML = plan["eah"] ? plan["eah"] : "";
    td.appendChild( tag );

    /**
     * Percent load
     */
    var td = document.createElement( "td" );
    td.setAttribute( "id", "td_load_" + planId );
    tr.appendChild( td );

    var tag = document.createElement( "div" );
    tag.setAttribute( "id", "text_load_" + planId );
    tag.innerHTML = plan["percent_load"] != undefined ? plan["percent_load"] + "%" : "N/A";
    td.appendChild( tag );
    calculateTdColor( "td_load_" + planId, plan["percent_load"] != undefined ? plan["percent_load"] : 0 )

    /**
     * Has SOW
     */
    var td = document.createElement( "td" );
    td.setAttribute( "id", "td_sow_" + planId );
    tr.appendChild( td );

    var tag = document.createElement( "input" );
    tag.type = "checkbox";
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }

    tag.setAttribute( "id", "checkbox_sow_" + planId );
    tag.checked = plan["has_sow"] == 1 ? true : false;
    td.appendChild( tag );

    var tag = document.createElement( "div" );
    tag.setAttribute( "id", "text_sow_" + planId );
    tag.innerHTML = plan["has_sow"] == 1 ? "yes" : "-";
    td.appendChild( tag );
    if ( isEmpty )
    {
        handleVisibility( tag );
    }

    /**
     * Status
     */
    var td = document.createElement( "td" );
    tr.appendChild( td );

    var tag = document.createElement( "select" );
    tag.style.width = "80%";
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "select_status_" + planId );
{/literal}
{foreach $status_list as $key => $name}
    var option = document.createElement( "option" );
    option.setAttribute( "id", {$key} );
    option.innerHTML = "{$name}";
    tag.appendChild( option );
    if ( plan["employee"] != undefined )
    {ldelim}
        if ( "{$key}" == plan["status"]["id"] )
        {ldelim}
            option.selected = "selected";
        {rdelim}
    {rdelim}
{/foreach}
{literal}
    if ( !isAdminAccess() )
    {
        tag.style.display = "none";
    }

    td.appendChild( tag );

    var tag = document.createElement( "div" );
    if ( isAdminAccess() && isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "text_status_" + planId );
    tag.innerHTML = plan["status"] != undefined ? plan["status"]["name"] : "Pending";
    td.appendChild( tag );


    /**
     * Control operations
     */
    var td = document.createElement( "td" );
    tr.appendChild( td );

    /**
     * Store
     */
    var tag = document.createElement( "a" );
    if ( !isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "link_store_" + planId );
    tag.onclick = function() { storePlan( planId ); };
    td.appendChild( tag );
{/literal}

    var img = document.createElement( "img" );

    img.setAttribute( "src", {"store.gif"|ezimage} );
{literal}
    tag.appendChild( img );

    /**
     * Edit
     */
    var tag = document.createElement( "a" );
    if ( isEmpty )
    {
        handleVisibility( tag );
    }
    tag.setAttribute( "id", "link_edit_" + planId );
    tag.onclick = function() { handleRow( planId, [] ); };
    td.appendChild( tag );

    var img = document.createElement( "img" );
    if ( !isAdminAccess() )
    {
        tag.style.display = "none";
    }

{/literal}
    img.setAttribute( "src", {"edit.gif"|ezimage} );
{literal}
    tag.appendChild( img );

    /**
     * remove
     */
    var td = document.createElement( "td" );
    tr.appendChild( td );

    var tag = document.createElement( "a" );
    tag.setAttribute( "id", "link_remove_" + planId );
    tag.onclick = function() { removePlan( planId ); };
    td.appendChild( tag );

    var img = document.createElement( "img" );
{/literal}
    img.setAttribute( "src", {"trash-icon-16x16.gif"|ezimage});
{literal}
    tag.appendChild( img );
    if ( !isAdminAccess() && !isEmpty )
    {
        tag.style.display = "none";
    }
}

/**
 * Removes plan
 */
function removePlan( planId )
{
    if ( !confirmRemove( "Are you sure that you want to remove the row?" ) )
    {
        return false;
    }

    disableRow( planId );
    if ( planId.indexOf( "new_", planId ) == 0 )
    {
        hideRow( planId );
        return false;
    }

    jQuery.ez( "nxcplanServer::removePlan::" + planId, {}, remove_callBack );

    return false;
}

/**
 * Callback for removePlan
 */
function remove_callBack( data )
{
    if ( !data )
    {
        return;
    }

    if ( data.content["error"] != undefined )
    {
        alert( data.content["error"] );
        enableRow( data.content["old_id"], true );
        return;
    }

    hideRow( data.content["id"] );
}

/**
 * Hides row
 */
function hideRow( planId )
{
    var element = document.getElementById( "tr_" + planId );
    element.style.display = "none";
}

/**
 * Disables row
 */
function disableRow( planId )
{
    var element = document.getElementById( "select_project_" + planId );
    element.disabled = "disabled";
    var element = document.getElementById( "select_employee_" + planId );
    element.disabled = "disabled";
    var element = document.getElementById( "edit_comment_" + planId );
    element.disabled = "disabled";
    var element = document.getElementById( "edit_start_week_" + planId );
    element.disabled = "disabled";
    var element = document.getElementById( "edit_end_week_" + planId );
    element.disabled = "disabled";
    var element = document.getElementById( "edit_eah_" + planId );
    element.disabled = "disabled";
    var element = document.getElementById( "select_status_" + planId );
    element.disabled = "disabled";
}

/**
 * Enables row
 */
function enableRow( planId, isError )
{
    if ( isError == undefined )
    {
        isError = false;
    }

    var element = document.getElementById( "select_project_" + planId );
    element.disabled = false;
    var element = document.getElementById( "select_employee_" + planId );
    element.disabled = false;
    var element = document.getElementById( "edit_comment_" + planId );
    element.disabled = false;
    var element = document.getElementById( "edit_start_week_" + planId );
    element.disabled = false;
    var element = document.getElementById( "edit_end_week_" + planId );
    element.disabled = false;
    var element = document.getElementById( "edit_eah_" + planId );
    element.disabled = false;
    var element = document.getElementById( "select_status_" + planId );
    element.disabled = false;
    if ( !isAdminAccess() && !isError )
    {
        var element = document.getElementById( "link_remove_" + planId );
        element.style.display = "none";
    }
}

/**
 * Stores plan to database
 */
function storePlan( planId )
{
    disableRow( planId );

    var element = document.getElementById( "select_project_" + planId );
    var projectId = element.options[element.selectedIndex].id;

    var element = document.getElementById( "select_employee_" + planId );
    var employeeId = element.options[element.selectedIndex].id;

    var element = document.getElementById( "edit_comment_" + planId );
    var comment = element.value;

    var element = document.getElementById( "edit_start_week_" + planId );
    var startWeek = element.value;

    var element = document.getElementById( "edit_end_week_" + planId );
    var endWeek = element.value;

    var element = document.getElementById( "edit_eah_" + planId );
    var eah = element.value;

    var element = document.getElementById( "checkbox_sow_" + planId );
    var hasSow = element.checked ? 1 : 0;

    var element = document.getElementById( "select_status_" + planId );
    var status = element.options[element.selectedIndex].id;

    var args = planId + "::" + projectId + "::" + employeeId + "::" + comment + "::" + startWeek + "::" + endWeek + "::" + getYear() + "::" + eah + "::" + hasSow + "::" + status;

    jQuery.ez( "nxcplanServer::storePlan::" + args, {}, store_callBack );

    return false;
}

/**
 * Callback for storePlan()
 */
function store_callBack( data )
{
    if ( !data )
    {
        return;
    }

    if ( data.content["error"] != undefined )
    {
        alert( data.content["error"] );
        enableRow( data.content["old_id"], true );
        return;
    }

    jQuery.ez( "nxcplanServer::fetchPlan::" + data.content["id"] + "::" + data.content["old_id"], {}, fetch_callBack );
}

/**
 * Callback for store_callBack()
 */
function fetch_callBack( data )
{
    if ( !data )
    {
        return;
    }

    if ( data.content["error"] != undefined )
    {
        alert( data.content["error"] );
        enableRow( data.content["old_id"], true );
        return;
    }

    addHandleRowWhenHidden( data.content["old_id"], data.content["id"] );

    handleRow( data.content["old_id"], data.content );
}

/**
 * Addes event to handle by clicking on Enter
 */
function initEnterClick( element, planId )
{
    if ( element == undefined )
    {
        return;
    }

    element.onkeyup = function( event ) { if ( event.keyCode == 13 ) { storePlan( planId );} };
}

/**
 * Handles visibility
 */
function handleVisibility( element )
{
    if ( element == undefined )
    {
        return;
    }

    element.style.display = element.style.display == "none" ? "inline" : "none";
}

/**
 * Handles row
 */
function handleRow( planId, valueList )
{
    valueList = valueList == undefined ? [] : valueList;
    enableRow( planId );

    /**
     * Projects
     */
    var element = document.getElementById( "select_project_" + planId );
    if ( valueList["id"] != undefined )
    {
        var tr = document.getElementById( "tr_" + planId );
        tr.setAttribute( "id", "tr_" + valueList["id"] );

        element.setAttribute( "id", "select_project_" + valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "link_project_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "link_project_" + valueList["id"] );
    }

    if ( valueList["project"] != undefined )
    {
        element.innerHTML = valueList["project"]["name"];
        element.href = valueList["project"]["url"];
        element.title = valueList["project"]["description"];
    }
    handleVisibility( element );

    /**
     * Lead
     */
    var element = document.getElementById( "link_lead_" + planId );
    if ( valueList["project"] != undefined )
    {
        element.innerHTML = valueList["project"]["lead"]["name"];
        element.href = valueList["project"]["lead"]["url"];
    }
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "link_lead_" + valueList["id"] );
    }

    /**
     * Employee
     */
    var element = document.getElementById( "select_employee_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "select_employee_" + valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "link_employee_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "link_employee_" + valueList["id"] );
    }

    if ( valueList["employee"] != undefined )
    {
        element.innerHTML = valueList["employee"]["name"];
        element.href = valueList["employee"]["url"];
        element.title = valueList["employee"]["full_name"];
    }
    handleVisibility( element );

    /**
     * Comment
     */
    var element = document.getElementById( "edit_comment_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "edit_comment_" + valueList["id"] );
        initEnterClick( element, valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "text_comment_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "text_comment_" + valueList["id"] );
    }

    if ( valueList["comment"] != undefined )
    {
        element.innerHTML = valueList["comment"];
    }
    handleVisibility( element );

    /**
     * Start week
     */
    var element = document.getElementById( "edit_start_week_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "edit_start_week_" + valueList["id"] );
        initEnterClick( element, valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "img_start_week_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "img_start_week_" + valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "text_start_week_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "text_start_week_" + valueList["id"] );
    }

    if ( valueList["start_week"] != undefined )
    {
        element.innerHTML = valueList["start_week"];
    }
    handleVisibility( element );

    /**
     * End week
     */
    var element = document.getElementById( "edit_end_week_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "edit_end_week_" + valueList["id"] );
        initEnterClick( element, valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "img_end_week_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "img_end_week_" + valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "text_end_week_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "text_end_week_" + valueList["id"] );
    }

    if ( valueList["end_week"] != undefined )
    {
        element.innerHTML = valueList["end_week"];
    }
    handleVisibility( element );

    /**
     * Eah
     */
    var element = document.getElementById( "edit_eah_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "edit_eah_" + valueList["id"] );
        initEnterClick( element, valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "text_eah_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "text_eah_" + valueList["id"] );
    }

    if ( valueList["eah"] != undefined )
    {
        element.innerHTML = valueList["eah"];
    }
    handleVisibility( element );

    /**
     * Load
     */
    var element = document.getElementById( "text_load_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "text_load_" + valueList["id"] );
    }

    if ( valueList["percent_load"] != undefined )
    {
        element.innerHTML = valueList["percent_load"] + "%";
    }

    var tdId = "td_load_" + planId;
    var element = document.getElementById( tdId );
    if ( valueList["id"] != undefined )
    {
        tdId = "td_load_" + valueList["id"];
        element.setAttribute( "id", "td_load_" + valueList["id"] );
    }
    calculateTdColor( tdId, valueList["percent_load"] != undefined ? valueList["percent_load"] : 0 )

    /**
     * Has SOW
     */
    var element = document.getElementById( "checkbox_sow_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "checkbox_sow_" + valueList["id"] );
        initEnterClick( element, valueList["id"] );
    }
    handleVisibility( element );

    var element = document.getElementById( "text_sow_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "text_sow_" + valueList["id"] );
    }

    element.innerHTML = valueList["has_sow"] == 1 ? "yes" : "-";
    handleVisibility( element );

    if ( isAdminAccess() )
    {
        var element = document.getElementById( "select_status_" + planId );
        if ( valueList["id"] != undefined )
        {
            element.setAttribute( "id", "select_status_" + valueList["id"] );
        }
        handleVisibility( element );

        var element = document.getElementById( "text_status_" + planId );
        if ( valueList["id"] != undefined )
        {
            element.setAttribute( "id", "text_status_" + valueList["id"] );
        }

        if ( valueList["status"] != undefined )
        {
            element.innerHTML = valueList["status"]["name"];
        }
        handleVisibility( element );
    }

    var element = document.getElementById( "link_store_" + planId );
    if ( valueList["id"] != undefined )
    {
        element.setAttribute( "id", "link_store_" + valueList["id"] );
        element.onclick = function() { storePlan( valueList["id"] ); };
    }
    handleVisibility( element );

    if ( isAdminAccess() )
    {
        var element = document.getElementById( "link_edit_" + planId );
        if ( valueList["id"] != undefined )
        {
            element.setAttribute( "id", "link_edit_" + valueList["id"] );
            element.onclick = function() { handleRow( valueList["id"] ); };
        }
        handleVisibility( element );

        var element = document.getElementById( "link_remove_" + planId );
        if ( valueList["id"] != undefined )
        {
            element.setAttribute( "id", "link_remove_" + valueList["id"] );
            element.onclick = function() { removePlan( valueList["id"] ); };
        }
    }
}

/**
 * Confirms remove
 */
function confirmRemove( question )
{
    // Ask user if he really wants to do it.
    return confirm( question );
}

-->
</script>
{/literal}
