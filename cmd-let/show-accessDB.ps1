##
##show-accessDB: view objects inside an access DB 
##for now: just Tables.

function show-accessDB {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [system.io.fileinfo]$file,
        
        [parameter(Mandatory=$false)]
        [alias("PF")]
        [switch]$pingfirst
        
    )
    PROCESS {
        $connection = New-Object System.Data.OleDb.OleDbConnection("Provider = Microsoft.ACE.OLEDB.12.0;Data Source=$file")
        $connection.Open()
        
        $tables = $connection.getSchema("Tables")
        $columns = $connection.getSchema("Columns")

        write-output "========================================"
        
        foreach ($table in $tables){
            if ($table.table_type -eq "TABLE"){
                Write-output $table.table_name.padright(30)
                
                foreach ($col in $columns){
                    if ($col.table_name -eq $table.table_name){
                        write-output ("{0} (type {1})" -f $col.column_name,$col.DATA_TYPE)
                    }
                }
            }
        }
        write-output "========================================"
        
        $connection.Close()
        
        
    
    }#end process
}#end function