# check-windows-process.ps1
#
# DESCRIPTION:
# This plugin checks whether a User-inputted process is running or not.
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
   [string]$ProcessName
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Exists = Get-Process $ProcessName -ErrorAction SilentlyContinue

If (!$Exists) {
  Write-Host CRITICAL: $ProcessName not found!
  Exit 2 }

If ($Exists) {
  Write-Host OK: $ProcessName running.
  Exit 0 }
