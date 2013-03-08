<div id="header-logo">
    <span title="NXC Resource plan">&nbsp;</span>
</div>

<div id="header-usermenu">
    {if $current_user.is_logged_in}
        {$current_user.login|wash} (<a href={'/user/logout'|ezurl} title="{'Logout from the system.'|i18n( 'design/admin/pagelayout' )}" id="header-usermenu-logout">{'Logout'|i18n( 'design/admin/pagelayout' )}</a>)
    {else}
        <a href={"/user/login"|ezurl} title="Login">Login</a>
    {/if}

</div>

