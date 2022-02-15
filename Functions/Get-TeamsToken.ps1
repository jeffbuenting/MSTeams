Function Get-TeamsToken {

<#
    .SYNOPSIS
        Retrieves a MS Teams token
    
    .LINKS
        https://www.reddit.com/r/MicrosoftTeams/comments/k5w349/script_for_keeping_available_status_perpetually/
#>

    [CmdletBinding()]
    Param ()

    $TokenLogPath = "$env:AppData\Microsoft\Teams\Local Storage\leveldb\"

    $TokenLog = Get-ChildItem -path $TokenLogPath -filter *.log | Get-Content

    $Token = ($TokenLog | Select-String  -Pattern '"token":"([\s\S]*?)"').matches.Groups[1].value

    Write-Output $Token
}

