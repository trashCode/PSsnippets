function Out-Excel

{

  param($Path = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv")

  $input | Export-CSV -Path $Path -UseCulture -Encoding UTF8 -NoTypeInformation

  Invoke-Item -Path $Path

}

function int2date {
    param($entier)
    return (get-date("30/12/1899")).addDays($entier)
}

$MyServer = "w11690100stf"
#$MyServer = "s116901d0000118"
$Myport = 5434
$MyDB = "visiodent"
$MyUid = "postgres"
$MyPass = gc db.pass

#ACTES CCAM
$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

#query
$cmd = $DBConn.CreateCommand()
$cmd.CommandText = "select libelleacte,nompraticien,datedelacte  from tblactesspo inner join tblpraticiens on tblactesspo.indexpraticien = tblpraticiens.indexpraticien where libelleacte like '%implant%'"
$reader = $cmd.ExecuteReader()

$data = @()

    while ($reader.read()){
        
        #on ajoute toutes les colones avec leur valeur dans un hashTable.
        $data += New-Object PSObject -property @{
            acte = $reader[0]
            praticien = $reader[1]
            date = int2date($reader[2])
        }
    }
    
$reader.close()
$DBConn.close()

$data |out-excel



