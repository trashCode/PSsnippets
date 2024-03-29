$datasource = "\\w11690100snf\WVISIO32\Neuville.mdb"
$connection = New-Object System.Data.OleDb.OleDbConnection("Provider = Microsoft.Jet.OLEDB.4.0; Data Source=$datasource;")
$connection.Open()

$tables = $connection.getSchema("Tables")
$columns = $connection.getSchema("Columns")
$connection.Close()

$typeNames = [System.data.OleDb.OleDbType].getmembers() |where {$_.memberType -eq "Field" -and $_.FieldType.toString() -eq "System.Data.OleDb.OleDbType"}|select name
$allTypes = @();
$typeNames |foreach {
    $allTypes += [System.data.OleDb.OleDbType]::($_.name)
}



foreach ($table in $tables){
    if ($table.table_type -eq "TABLE"){
        write-host("")
        Write-host($table.table_name)
        Write-host('='*$table.table_name.length)
        
        foreach ($col in $columns){
            if ($col.table_name -eq $table.table_name){
                write-host ("{0} ({1})" -f $col.column_name , ($allTypes |where {$_.value__ -eq $col.DATA_TYPE}).toString())
            }
        }
    }
}
