#$connection = New-Object System.Data.SqlClient.SqlConnection
$datasource = 'D:\VISIODATA.MDB'
#$datasource = '\\w11690100snf\WVISIO32\Neuville.mbd'
$connection2 = New-Object System.Data.OleDb.OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D:\PIF.accdb;Persist Security Info=False;")
$connection2 = New-Object System.Data.OleDb.OleDbConnection("Provider = Microsoft.Jet.OLEDB.4.0; Data Source = $datasource;")
$connection2.Open()

#infos sur le schema
$tables = $connection2.getSchema("Tables")
$columns = $connection2.getSchema("Columns")
#$tables|ogv

write-host "========================================"
foreach ($table in $tables){
    if ($table.table_type -eq "TABLE"){
        Write-host $table.table_name.padright(30) -foreground darkBlue -background darkcyan
        #$columns |where_object {$_.Table_name -eq $table.table_name}|%{$_.Column_name}
        foreach ($col in $columns){
            if ($col.table_name -eq $table.table_name){
                write-host $col.column_name.padright(26) $col.DATA_TYPE
            }
        }
    }
}
write-host "========================================"




$typeNames = [System.data.OleDb.OleDbType].getmembers() |where {$_.FieldType.toString() -eq "System.Data.OleDb.OleDbType"}|select name
$allTypes = @();
$typeNames |foreach {
    $allTypes += [System.data.OleDb.OleDbType]::($_.name)
}
#liste des types avec leur valeures :
$allTypes |%{"{0}   {1}" -f $_.toString(), $_.value__}





$ignore = @"
$commande = New-Object System.Data.OleDb.OleDbCommand
$commande.commandText = "Select * from users"
$commande.commandText = "Select count(*) from factdef"
$commande.connection = $connection2

write-host $connection2.state -backgroundcolor blue -foregroundcolor white

$rs = $commande.ExecuteReader()

$table = new-object “System.Data.DataTable”
$table.Load($rs)
$table |ogv
"@

$connection2.Close()
write-host "EOF" -backgroundcolor blue -foregroundcolor white
