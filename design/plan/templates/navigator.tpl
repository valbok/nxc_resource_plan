<table border=0 width="100%">
    <tr>
        <td align="center">
            <table>
                <tr>
                    <td width="80%">

                        {def $view_parameter_text = ''
                             $print_start_month = $start_month
                             $print_prev_year = $year
                             $print_next_year = $year}

                        {foreach $view_parameters as $name => $value}
                            {if and( $name|ne( "year" ), $name|ne( "start_month" ) )}
                                {set $view_parameter_text = concat( $view_parameter_text, '/(', $name, ')/', $value )}
                            {/if}
                        {/foreach}

                        <div class="pagenavigator">
                            <span class="previous">
                                {if eq( $start_month, 1 )}
                                    {set $print_start_month = 12
                                         $print_prev_year = sub( $year, 1 )}
                                    {else}
                                        {set $print_start_month = sub( $start_month, 1 )}
                                    {/if}

                                <a href={concat( $url, $view_parameter_text, "/(year)/", $print_prev_year, '/(start_month)/', $print_start_month )|ezurl}><< {$previous_month|wash}</a>
                            </span>
                            <span class="pages">
                                <span style="color: #666666">{$current_month|wash}</span>
                            </span>
                            <span class="next">
                                {if eq( $start_month, 12 )}
                                    {set $print_start_month = 1
                                         $print_next_year = sum( $year, 1 )}
                                    {else}
                                        {set $print_start_month = sum( $start_month, 1 )}
                                    {/if}

                                    <a href={concat( $url, $view_parameter_text, "/(year)/", $print_next_year, "/(start_month)/", $print_start_month )|ezurl}>{$next_month|wash} >></a>
                            </span>

                        </div>

                        {undef $view_parameter_text $print_start_month $print_prev_year $print_next_year}
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

