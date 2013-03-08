<div id="header-topmenu">
    <ul>
    {def $menu_list = array( "projects", "resource_plan" )
         $navigationpart_identifier = ""
         $url = ""
         $name = ""
         $liclass= "unselected"}

    {foreach $menu_list as $menu}
        {set $navigationpart_identifier = ezini( concat( "Topmenu_", $menu ), "NavigationPartIdentifier", "menu.ini")
             $url = ezini( concat( "Topmenu_", $menu ), "URL", "menu.ini")
             $name = ezini( concat( "Topmenu_", $menu ), "Name", "menu.ini")}

        {set $liclass='unselected '}
        {if eq( $navigation_part.identifier, $navigationpart_identifier ) }
            {set $liclass='selected '}
        {/if}
        <li class="{$liclass}{$menu_item.position} {$navigationpart_identifier}">
            <div>
                <a href={$url|ezurl} title="{$name}">{$name|wash}</a>
            </div>
        </li>

    {/foreach}

    {undef $liclass $navigationpart_identifier $url $name}

    </ul>
</div>
