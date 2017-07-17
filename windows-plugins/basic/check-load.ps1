# check-windows-cpu-load.ps1
#
# DESCRIPTION:
# This plugin collects the CPU Usage and compares WARNING and CRITICAL thresholds.
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

#$Value = (Get-WmiObject CIM_Processor).LoadPercentage
$Value=(get-counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 60 -MaxSamples 5 |
    select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average

If ($Value -gt $CRITICAL) {
  Write-Host CheckWindowsCpuLoad CRITICAL: CPU at $Value%.
  Exit 2 }

If ($Value -gt $WARNING) {
  Write-Host CheckWindowsCpuLoad WARNING: CPU at $Value%.
  Exit 1 }

Else {
  Write-Host CheckWindowsCpuLoad OK: CPU at $Value%.
  Exit 0 }
