# check-windows-service.ps1
#
# DESCRIPTION:
# This plugin checks whether a User-inputted Windows service is running or not.
#
# OUTPUT:
# Check Result in Plain Text
#
# PLATFORMS:
# Windows
#
# DEPENDENCIES:
# Powershell
#
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$ServiceName
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Exists = Get-Service $ServiceName -ErrorAction SilentlyContinue

If ($Exists) {
  If (($Exists).Status -eq "Running") {
    Write-Host OK: $ServiceName Running.
    Exit 0 }

  If (($Exists).Status -eq "Stopped") {
    Write-Host CRITICAL: $ServiceName Stopped.
    Exit 2 }
}

If (!$Exists) {
  Write-Host CRITICAL: $ServiceName not found!
  Exit 2 }
