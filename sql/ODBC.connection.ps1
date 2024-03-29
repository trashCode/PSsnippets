$DBConnectionString = "Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq=\\w11690100suf\APP-ACCESS\FNI\Database1.accdb;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();


$tables =$DBCOnn.getSchema('TABLES') |where-object {$_.TABLE_TYPE -eq 'TABLE'}

$cmd = $DBConn.createcommand()
$cmd.CommandText = 'CREATE TABLE table2 (index2 counter, nom2 text)'
$cmd.ExecuteNonQuery()

$cmd.CommandText = 'DROP TABLE table2'
$cmd.ExecuteNonQuery()

$DBConn.close()

write-host "EOF" -backgroundcolor blue -foregroundcolor white