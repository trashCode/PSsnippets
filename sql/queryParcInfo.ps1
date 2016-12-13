$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = "driver={SQL Server};server=w11690100saf; database=parcinfo"
$DBConn.Open();

$seek = "s116901D0000122"
$seek = [Windows.ClipBoard]::GetText();
$cmd = $DBConn.CreateCommand()

$cmd.commandText = ("select userName,count(*) as nb from session where machineName = '{0}' group by username order by count(*) DESC" -f $seek)
$reader = $cmd.ExecuteReader()
[void]$reader.read()
$reader[0] |clip
<#
while ($reader.read()){
    Write-host ("{0} {1}" -f $reader[0], $reader[1])
}#>
$reader.Close()
$DBConn.Close()