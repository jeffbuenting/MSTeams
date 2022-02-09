Fucntion Set-TeamsPresence {

<#
    .SYNOPSIS
        Set Teams presence for local user.
#>

    [CmdletBinding()]
    Param ( 
        [Parameter (Mandatory = $true)]
        [ValidateSet ('Available','Busy','Do not disturb','Be right back','Away','Offline')]
        [String]$Presence
    )

    
}