###########################################################################
#
# NAME: Get Computer Uptime
#
# AUTHOR:  randolph.brady
#
# COMMENT:
#
# VERSION HISTORY:
# 1.0 1/23/2012 – Initial release
#
###########################################################################

$computer = read-host "Please type in computer name you would like to check uptime on"

$lastboottime = (Get-WmiObject -Class Win32_OperatingSystem -computername $computer).LastBootUpTime

$sysuptime = (Get-Date) – [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)
 
Write-Host "$computer has been up for: " $sysuptime.days "days" $sysuptime.hours "hours" $sysuptime.minutes "minutes" $sysuptime.seconds "seconds" 