$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 0}|where {$_.IPAddress[0] -like "55*"}
$ip

$ip2 = get-wmiObject -query "select * from Win32_NetworkAdapterConfiguration where IPEnabled = 'True'"
$ip2

$ip3 = get-wmiObject -query "select * from Win32_NetworkAdapterConfiguration where IPAddress like '55\%'" #ne marche pas
$ip3
