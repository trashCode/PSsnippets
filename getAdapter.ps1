get-wmiobject -computerName "P116901C0000211"-class Win32_networkAdapter | where {$_.adapterType -like 'Ethernet*'}|select name,speed
