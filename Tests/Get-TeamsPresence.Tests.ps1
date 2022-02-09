# ----- Get the module name
if ( -Not $PSScriptRoot ) { 
    $ScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent 
}
else {
    $ScriptRoot = $PSScriptRoot
}

# ----- remove the tests folder from the path so we have the modules root
$ModulePath = $ScriptRoot | Split-Path

$Global:ModuleName = $ModulePath | Split-Path -Leaf

# ----- Remove and then import the module.  This is so any new changes are imported.
Get-Module -Name $ModuleName -All | Remove-Module -Force 

Import-Module  $( Join-Path -Path $ModulePath -ChildPath  "$($ModuleName).psd1" ) 

#-------------------------------------------------------------------------------------

InModuleScope -ModuleName $ModuleName {
    Describe "$ModuleName : Get-TeamsPresence" {
        BeforeAll {
            Mock -CommandName Get-Content -MockWith {
                Return "Setting the taskbar overlay icon - Available"
            }
        }

        It 'Should return presence setting' {   
            Get-TeamsPresence | Should -be 'Available'
        }

    }
}