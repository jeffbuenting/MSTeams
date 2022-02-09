Function Get-TeamsPresence {

    <#
        .SYOPSIS
            Retrieves local user MS Teams Presence.

    #>

    [CmdletBinding()]
    Param ()

    # ----- Using the Teams log to find the current presene
    $TeamsStatus = Get-Content -Path $env:APPDATA"\Microsoft\Teams\logs.txt" -Tail 1000 | Select-String -Pattern 'Setting the taskbar overlay icon -','StatusIndicatorStateService: Added' | Select-Object -Last 1

    # ----- Get Teams Logfile and last app update deamon status
    #$TeamsActivity = Get-Content -Path $env:APPDATA"\Microsoft\Teams\logs.txt" -Tail 1000 | Select-String -Pattern 'Resuming daemon App updates','Pausing daemon App updates','SfB:TeamsNoCall','SfB:TeamsPendingCall','SfB:TeamsActiveCall','name: desktop_call_state_change_send, isOngoing' | Select-Object -Last 1

    # ----- Get Teams application process
    $TeamsProcess = Get-Process -Name Teams -ErrorAction SilentlyContinue

    if ( $Null -eq $TeamsProcess ) {
        Throw "Get-TeamsPresence : Teams is not running."
    }

    Switch ( $TeamsStatus ) {
        { $_ -like "*Setting the taskbar overlay icon - Available*" -or $_ -like "*StatusIndicatorStateService: Added Available*" -or $_ -like "*StatusIndicatorStateService: Added NewActivity (current state: Available -> NewActivity*" } {
            $Status = 'Available'
        }

        { $_ -like "*Setting the taskbar overlay icon - Busy*" -or $_ -like "*StatusIndicatorStateService: Added Busy*" -or $_ -like "*Setting the taskbar overlay icon - Busy*" -or $_ -like "*StatusIndicatorStateService: Added Busy*" -or $_ -like "*StatusIndicatorStateService: Added NewActivity (current state: Busy -> NewActivity*" } {
            $Status = 'Busy'
        }

        { $_ -like "*Setting the taskbar overlay icon - Away*" -or $_ -like "*StatusIndicatorStateService: Added Away*" -or $_ -like "*StatusIndicatorStateService: Added NewActivity (current state: Away -> NewActivity*" } {
            $Status = 'Away'
        }

        { $_ -like "*Setting the taskbar overlay icon - Be Right Back*" -or $_ -like "*StatusIndicatorStateService: Added BeRightBack*" -or $_ -like "*StatusIndicatorStateService: Added NewActivity (current state: BeRightBack -> NewActivity*" } {
            $Status = 'Be Right Back'
        }

        { $_ -like "*Setting the taskbar overlay icon - Do not disturb*" -or $_ -like "*StatusIndicatorStateService: Added DoNotDisturb*" -or $_ -like "*StatusIndicatorStateService: Added NewActivity (current state: DoNotDisturb -> NewActivity*" } {
            $Status = 'Do not disturb'
        }

        { $_ -like "*Setting the taskbar overlay icon - Offline*" -or $_ -like "*StatusIndicatorStateService: Added Offline*" } {
            $Status = 'Offline'
        }

        Default {
            Throw "Get-TeamsPresence : Unknow or blank presence.`n`n     TeamsStatus = $TeamsStatus"
        }
    }

    Write-Output $Status

}