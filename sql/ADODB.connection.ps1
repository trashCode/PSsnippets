$adOpenStatic = 3
$adLockOptimistic = 3

$objConnection = New-Object -comobject ADODB.Connection
$objRecordset = New-Object -comobject ADODB.Recordset

$objConnection.Open("Provider = Microsoft.Jet.OLEDB.4.0; Data Source = d:\SuiviProd.mdb")

@"
$objRecordset.Open("Select * from TotalSales", $objConnection,$adOpenStatic,$adLockOptimistic)

$objRecordset.MoveFirst()

do {$objRecordset.Fields.Item("EmployeeName").Value; $objRecordset.MoveNext()} until 
    ($objRecordset.EOF -eq $True)

$objRecordset.Close()
"@
$objConnection.Close()

write-host "EOF" -backgroundcolor blue -foregroundcolor white