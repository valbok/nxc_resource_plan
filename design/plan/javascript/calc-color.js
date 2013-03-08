/**
 * Defines color for percent load
 */
function calculateTdColor( id, percent )
{
    var element = document.getElementById( id );
    if ( element == undefined || percent == 0 )
    {
        return;
    }

    var color = percent <= 60 ? "yellow" : ( percent > 60 && percent <= 85 ? "green" : ( percent > 85 && percent <= 100 ? "orange" : ( percent > 100 ? "red" : "" ) ) );

    if ( color != "" )
    {
        element.setAttribute( "bgcolor", color );
    }
}

