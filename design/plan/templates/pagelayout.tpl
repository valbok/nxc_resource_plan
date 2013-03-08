<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{$site.http_equiv.Content-language|wash}" lang="{$site.http_equiv.Content-language|wash}">
<head>
    {include uri='design:page_head.tpl'}

    {ezcss_load( array( 'core.css', 'debug.css', 'pagelayout.css', 'content.css', 'calendar.css', 'theme/rounded.css', ezini( 'StylesheetSettings', 'BackendCSSFileList', 'design.ini' ) ) )}
    {ezscript_load( array( 'ezjsc::jquery', 'ezjsc::jqueryio', 'calendar.js', 'calendar-en.js', 'calc-color.js' ) )}
</head>

<body>

<div id="page">

	<div id="header">
		<div id="header-design" class="float-break">

			{* HEADER ( SEARCH, LOGO AND USERMENU ) *}
			{include uri='design:page_header.tpl'}

			{* TOP MENU / TABS *}
			{include uri='design:page_topmenu.tpl'}
		</div>
	</div>

	<hr class="hide" />

	<div id="maincolumn">

		<hr class="hide" />

		<div id="maincontent">
			<div id="maincontent-design" class="float-break">
				<div id="fix">
					<!-- Maincontent START -->
					{include uri='design:page_mainarea.tpl'}
					<!-- Maincontent END -->
				</div>
				<div class="break"></div>
			</div>
		</div>
		{* Main area END *}
	</div>


	<div class="break"></div>
</div>

</body>
</html>
