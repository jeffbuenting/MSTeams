Function Set-TeamsPresence {

<#
    .SYNOPSIS
        Set Teams presence for local user.

    .LINKS
        https://www.reddit.com/r/MicrosoftTeams/comments/k5w349/script_for_keeping_available_status_perpetually/
#>

    [CmdletBinding()]
    Param ( 
        [Parameter (Mandatory = $true)]
        [String]$Token,

        [Parameter (Mandatory = $true)]
        [ValidateSet ('Available','Busy','Do not disturb','Be right back','Away','Offline')]
        [String]$Presence
    )


    # https://docs.microsoft.com/en-us/graph/auth-v2-service#3-get-administrator-consent
    # https://techcommunity.microsoft.com/t5/office-365/how-do-you-find-the-tenant-id/m-p/89018
    
    # $TennantID = 'd5fe813e-0caa-432a-b2ac-d555aa91bd1c'
    # $OAUTHURL = "https://login.microsoftonline.com/$TennantID/oauth2/v2.0/token"

    # $Body = @{grant_type='client_credentials'} | ConvertTo-Json

    # $Token = Invoke-RestMethod -Uri $OAUTHURL -Method Post -Body $Body

    $header = @{
        'Content-Type' = "application/json"
        Authorization = "Bearer $Token"
      } | ConvertTo-Json

    $JSONStatus = @{ availability = "Available" } | ConvertTo-Json

    Invoke-RestMethod -Uri  'https://presence.teams.microsoft.com/v1/me/forceavailability/' -Method Put -Body $JSONStatus -Headers $Header
}