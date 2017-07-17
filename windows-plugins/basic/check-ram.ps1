# check-windows-ram.ps1
#
# DESCRIPTION:
# This plugin collects the RAM Usage and compares WARNING and CRITICAL thresholds.
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
   [int]$WARNING,

   [Parameter(Mandatory=$True,Position=2)]
   [int]$CRITICAL
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Memory = (Get-WmiObject -Query "SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem")

$Value=(get-counter -Counter "\Memory\Available KBytes" -SampleInterval 60 -MaxSamples 5 |
    select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average

$Value = [System.Math]::Round(((($Memory.TotalVisibleMemorySize-$Value)/$Memory.TotalVisibleMemorySize)*100),2)

If ($Value -gt $CRITICAL) {
  Write-Host CheckWindowsRAMLoad CRITICAL: RAM at $Value%.
  Exit 2 }

If ($Value -gt $WARNING) {
  Write-Host CheckWindowsRAMLoad WARNING: RAM at $Value%.
  Exit 1 }

Else {
  Write-Host CheckWindowsRAMLoad OK: RAM at $Value%.
  Exit 0 }
