{def $adminAccess = fetch( 'user', 'has_access_to', hash( 'module', 'resource', 'function', 'admin' ) )
     $jscoreAccess = fetch( 'user', 'has_access_to', hash( 'module', 'ezjscore', 'function', 'call' ))}

<div class="context-block">
    <div class="box-ml">
        <div class="box-mr">
            <div class="box-content">

                <table cellspacing="0" class="list">
                <tbody>
                    <tr>
                        <th width="10px"></th>
                        <th width="10px"></th>
                        <th></th>
                        <th></th>

                        {def $colspan = 0
                             $oneYear = eq( count( $year_list ), 1 )}
                        {foreach $year_list as $yearKey => $month_list}
                            {foreach $month_list as $month => $list}
                                {if not( $oneYear )}
                                    <th style="text-align: center; font-weight: normal; color: #aaa; border-left: 1px solid grey;" colspan="{count($list)}">{$yearKey}</th>
                                {else}
                                    {set $colspan = $colspan|sum(count($list))}
                                {/if}
                            {/foreach}
                            {if $oneYear}
                                <th style="text-align: center;font-weight: normal; color: #aaa; border-left: 1px solid grey;" colspan="{$colspan}">{$yearKey}</th>
                            {/if}

                        {/foreach}

                        {undef $colspan $oneYear}

                    <tr>
                        <th width="10px"></th>
                        <th width="10px"></th>
                        <th></th>
                        <th></th>

                        {foreach $year_list as $yearKey => $month_list}
                            {foreach $month_list as $month => $list}
                                <th style="text-align: center; color: grey; border-left: 1px solid grey;" colspan="{count($list)}">{$month}</th>
                            {/foreach}
                        {/foreach}
                    </tr>

                    <tr>
                        <th></th>
                        <th></th>
                        <th width="13%" style="text-align: left">Department</th>
                        <th style="text-align: left">Employee</th>

                        {foreach $year_list as $yearKey => $month_list}
                            {foreach $month_list as $month => $list}
                                {foreach $list as $week => $userList}
                                    <th style="text-align: center; border-left: 1px solid grey;
                                        {if or( lt( $yearKey, $current_year ),
                                            and( eq( $yearKey, $current_year ), lt( $week, $current_week ) ) )}
                                            color: grey; font-weight: normal;
                                        {/if}">{$week}</th>
                                {/foreach}
                            {/foreach}
                        {/foreach}
                    </tr>

                    {if $jscoreAccess}
                    {foreach $employee_list as $user sequence array( "bgdark", "bglight" ) as $seq}
                        <tr class="{$seq}" id="tr_{$user.id}">
                            <td>
                                {if $adminAccess}
                                    <a id="link_remove_{$user.id}" onclick="disableEmployee( {$user.id} )"><img src={"trash-icon-16x16.gif"|ezimage}></a>
                                {/if}
                            </td>
                            <td>
                                {if $adminAccess}
                                    <a id="link_edit_{$user.id}" onclick="handleRow( {$user.id} )"><img src={"edit.gif"|ezimage}></a>
                                    <a id="link_store_{$user.id}" onclick="storeEmployee( {$user.id} )" style="display: none"><img src={"store.gif"|ezimage}></a>
                                {/if}
                            </td>
                            <td style="text-align: left">
                                <select id="select_department_{$user.id}" style="display: none">
                                {foreach $department_list as $department}
                                    <option id="{$department.id}" {if eq( $user.department.id, $department.id )}selected="selected"{/if}>{$department.name}</option>
                                {/foreach}
                                </select>
                                <a id="link_department_{$user.id}" href={concat( "resource/plan/(department_id)/", $user.department.id )|ezurl}>{$user.department.name|wash}</a>
                            </td>
                            <td style="text-align: left">
                                <a href={concat( "resource/plan/(user_id)/", $user.id )|ezurl} title="{$user.full_name}">{$user.name|wash}</a>
                            </td>

                            {foreach $year_list as $yearKey => $month_list}
                                {foreach $month_list as $month => $list}
                                    {foreach $list as $week => $userList}

                                        {def $week_list = false()
                                             $percent = 0
                                             $color = ""}
                                        {if is_set( $month_list[$month][$week][$user.id])}
                                            {set $week_list = fetch( "resource", "week_list", hash( "employee_id", $user.id, "week", $week, "year", $yearKey ) )
                                                 $percent = $week_list.percent_load}
                                        {/if}

                                        <td id="td_{$user.id}_{$week}" width="8%" style="{if or( lt( $yearKey, $current_year ), and( eq( $yearKey, $current_year ), lt( $week, $current_week ) ) )}color: grey;{else}font-weight: bold;{/if} text-align: center;">
                                            <div {if $week_list|is_array()}
                                                 onclick="showhint(
                                                          {foreach $week_list.plan_list as $plan}
                                                          {if array( 0, 2 )|contains( $plan.status )}
                                                              {set $color="gray"}
                                                          {/if}
                                                          '<a href=\'{$plan.project.url}\'>{$plan.project.name}</a>' +
                                                          '<br>' +
                                                          'Lead: <b>{$plan.project.lead}</b>' +
                                                          '<br>' +
                                                          'Weeks: <b>{$plan.start_week}</b> - <b>{$plan.end_week}</b>' +
                                                          '<br>' +
                                                          'Hours: <b>{$plan.eah}</b>' +
                                                          '<br>' +
                                                          'Load: <b>{$plan.percent_load}%</b>' +
                                                          '<br>' +
                                                          'Status: <b>{$plan.status_name}</b>'
                                                          {if and( $adminAccess, array( 0, 2 )|contains( $plan.status ) )}
                                                             + ' (<a onclick=\'approvePlan( {$plan.id} )\'>Approve</a>) '
                                                          {/if}
                                                          {delimiter}+'<hr>'+{/delimiter}
                                                      {/foreach}
                                                      , this, event, '200px' )"
                                               {/if}>
                                               {if gt( $percent, 0 )}
                                                   {$percent}%
                                               {/if}
                                            </div>
                                        </td>
{if or( gt( $yearKey, $current_year ), and( eq( $yearKey, $current_year ), ge( $week, $current_week ) ) )}
<script type="text/javascript">
<!--
    {if eq( $color, "" )}
        calculateTdColor( "td_{$user.id}_{$week}", {$percent} );
    {else}
        var element = document.getElementById( "td_{$user.id}_{$week}" );
        element.setAttribute( "bgcolor", "gray" );
    {/if}
-->
</script>
{/if}
                                        {undef $week_list $percent $color}
                                    {/foreach}
                                {/foreach}
                            {/foreach}
                        </tr>
                    {/foreach}
                    {/if}
                </tbody>
                </table>

                {include uri="design:navigator.tpl" start_month=$start_month url="resource/plan" year=$year}

            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

{def $view_parameter_text = ""}
{foreach $view_parameters as $name => $value}
    {set $view_parameter_text = concat( $view_parameter_text, "/(", $name, ")/", $value )}
{/foreach}

var Uri = "{concat( "resource/plan", $view_parameter_text )|ezurl( no )}";

{undef $view_parameter_text}

{literal}
/********
 * Hint *
 ********/

var horizontal_offset="2px"; //horizontal offset of hint box from anchor link
/////No further editting needed
var vertical_offset="0"; //horizontal offset of hint box from anchor link. No need to change.
var ie = document.all;
var ns6 = document.getElementById && !document.all;

function getposOffset( what, offsettype )
{
    var totaloffset=(offsettype=="left")? what.offsetLeft : what.offsetTop;
    var parentEl=what.offsetParent;
    while ( parentEl != null )
    {
        totaloffset=(offsettype=="left")? totaloffset+parentEl.offsetLeft : totaloffset+parentEl.offsetTop;
        parentEl=parentEl.offsetParent;
    }

     return totaloffset;
}

function iecompattest()
{
    return ( document.compatMode && document.compatMode != "BackCompat" )? document.documentElement : document.body;
}

function clearbrowseredge( obj, whichedge )
{

    var edgeoffset= ( whichedge == "rightedge" ) ? parseInt( horizontal_offset ) * -1 : parseInt( vertical_offset ) * -1;

    if ( whichedge == "rightedge" )
    {

        var windowedge=ie && !window.opera? iecompattest().scrollLeft+iecompattest().clientWidth - 30 : window.pageXOffset+window.innerWidth - 40;
        dropmenuobj.contentmeasure = dropmenuobj.offsetWidth;

        if ( windowedge - dropmenuobj.x < dropmenuobj.contentmeasure )
            edgeoffset=dropmenuobj.contentmeasure+obj.offsetWidth+parseInt(horizontal_offset)

    }
    else
    {
        var windowedge=ie && !window.opera ? iecompattest().scrollTop+iecompattest().clientHeight - 15 : window.pageYOffset + window.innerHeight - 18;
        dropmenuobj.contentmeasure = dropmenuobj.offsetHeight;

        if ( windowedge-dropmenuobj.y < dropmenuobj.contentmeasure )
            edgeoffset=dropmenuobj.contentmeasure-obj.offsetHeight;
    }

    return edgeoffset;
}


function showhint( menucontents, obj, e, tipwidth )
{
    if ( ( ie || ns6 ) && document.getElementById( "hintbox" ) )
    {
        dropmenuobj = document.getElementById( "hintbox" );
        dropmenuobj.innerHTML = menucontents;
        dropmenuobj.style.left = dropmenuobj.style.top = -500;
        if ( tipwidth != "" )
        {
            dropmenuobj.widthobj = dropmenuobj.style;
            dropmenuobj.widthobj.width = tipwidth;
        }

        dropmenuobj.x = getposOffset( obj, "left" );
        dropmenuobj.y = getposOffset( obj, "top" );
        dropmenuobj.style.left = e.clientX - clearbrowseredge( obj, "rightedge" ) + 10 + "px";// + obj.offsetWidth + "px"
        dropmenuobj.style.top = dropmenuobj.y - clearbrowseredge( obj, "bottomedge" )+"px";
        dropmenuobj.style.visibility = "visible";
        dropmenuobj.onclick = hidetip;
    }
}

function hidetip( e )
{
    dropmenuobj.style.visibility = "hidden";
    dropmenuobj.style.left = "-500px";
}

function createhintbox()
{
    var divblock = document.createElement( "div" );
    divblock.setAttribute( "id", "hintbox" );
    document.body.appendChild( divblock );
}

if ( window.addEventListener )
    window.addEventListener( "load", createhintbox, false );
else if ( window.attachEvent )
    window.attachEvent( "onload", createhintbox );
else if ( document.getElementById )
    window.onload = createhintbox;

/**********************/
/*  Control functions */
/**********************/

/**
 * Disables employee by id
 */
function disableEmployee( id )
{
    if ( !confirmRemove( "Are you sure that you want to remove the row?" ) )
    {
        return false;
    }

    disableRow( id );
    jQuery.ez( "nxcplanServer::disableEmployee::" + id, {}, disable_callBack );

    return false;
}

/**
 * Callback for disableEmployee()
 */
function disable_callBack( data )
{
    if ( !data )
    {
        return;
    }

    if ( data.content["error"] != undefined )
    {
        alert( data.content["error"] );
        enableRow( data.content["id"], [] );
        return;
    }

    hideRow( data.content["id"] );
}

/**
 * Stores employee to database
 */
function storeEmployee( id )
{
    disableRow( id );

    var element = document.getElementById( "select_department_" + id );
    var departmentId = element.options[element.selectedIndex].id;

    var args = id + "::" + departmentId;

    jQuery.ez( "nxcplanServer::storeEmployee::" + args, {}, store_callBack );

    return false;
}

/**
 * Callback for storeEmployee()
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
        enableRow( data.content["id"], [] );
        return;
    }

    jQuery.ez( "nxcplanServer::fetchEmployee::" + data.content["id"], {}, fetch_callBack );
}

/**
 * Callback for store_callBack
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
        enableRow( data.content["id"], [] );
        return;
    }

    handleRow( data.content["id"], data.content );
}

/**
 * Hides row
 */
function hideRow( id )
{
    var element = document.getElementById( "tr_" + id );
    element.style.display = "none";
}

/**
 * Disables row
 */
function disableRow( id )
{
    var element = document.getElementById( "select_department_" + id );
    element.disabled = "disabled";
}

/**
 * Enables row
 */
function enableRow( id )
{
    var element = document.getElementById( "select_department_" + id );
    element.disabled = false;
}

/**
 * Handles element visibility
 * If it is hidden it will be shown, otherwise will be hidden
 */
function handleVisibility( element )
{
    element.style.display = element.style.display == "none" ? "inline" : "none";
}

/**
 * Handles the row. Shows not visible fields, hides visible etc
 */
function handleRow( id, valueList )
{
    valueList = valueList == undefined ? [] : valueList;
    enableRow( id );

    var element = document.getElementById( "select_department_" + id );
    handleVisibility( element );

    var element = document.getElementById( "link_department_" + id );
    if ( valueList["department"] != undefined )
    {
        element.innerHTML = valueList["department"]["name"];
{/literal}
        element.href = {"resource/plan/(department_id)/"|ezurl} + "/" + valueList["department"]["id"];
{literal}
    }
    handleVisibility( element );

    var element = document.getElementById( "link_store_" + id );
    handleVisibility( element );

    var element = document.getElementById( "link_edit_" + id );
    handleVisibility( element );
}


/**
 * Approves plan
 */
function approvePlan( planId )
{
    var args = planId + "::" +  "::" + "::" + "::" + "::" + "::" + "::" + "::" + "::" + 1;

    jQuery.ez( "nxcplanServer::storePlan::" + args, {}, approve_callBack );

    return false;
}

/**
 * Callback for approvePlan()
 */
function approve_callBack( data )
{
    if ( !data )
    {
        return;
    }

    if ( data.content["error"] != undefined )
    {
        alert( data.content["error"] );
        return;
    }

    window.location = Uri;
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
