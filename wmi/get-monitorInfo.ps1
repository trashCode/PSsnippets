Function Get-MonitorInfo
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
        Position=0,
        ValueFromPipeLine=$true,
        ValueFromPipeLineByPropertyName=$true)]
        [string]$name = '.'
    )
 
    Process
    {

        $ActiveMonitors = Get-WmiObject -Namespace "root\WMI" -Class wmiMonitorID -ComputerName $name
        $monitorInfo = @()
 
        foreach ($monitor in $ActiveMonitors)
        {
            $mon = New-Object PSObject
            $manufacturer = $null
            $product = $null
            $serial = $null
            $name = $null
            $week = $null
            $year = $null
 
            $monitor.ManufacturerName | foreach {$manufacturer += [char]$_}
            $monitor.ProductCodeID | foreach {$product += [char]$_}
            $monitor.SerialNumberID | foreach {$serial += [char]$_}
            $monitor.UserFriendlyName | foreach {$name += [char]$_}
 
            $mon | Add-Member NoteProperty Manufacturer $manufacturer
            $mon | Add-Member NoteProperty ProductCode $product
            $mon | Add-Member NoteProperty SerialNumber $serial
            $mon | Add-Member NoteProperty Name $name
            $mon | Add-Member NoteProperty Week $monitor.WeekOfManufacture
            $mon | Add-Member NoteProperty Year $monitor.YearOfManufacture
 
            $monitorInfo += $mon
        }
        $monitorInfo
    }
}