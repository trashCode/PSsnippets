function Out-Excel

{

  param($Path = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv")

  $input | Export-CSV -Path $Path -UseCulture -Encoding UTF8 -NoTypeInformation

  Invoke-Item -Path $Path

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
$cmd.CommandText = "select libellelong,codeacte,libelleacte,ccam_honoraire from tblparamactes INNER JOIN tblparamgeneraux ON tblparamgeneraux.codedonnee = tblparamactes.familledacte where codeacteCCAM != '';"
$reader = $cmd.ExecuteReader()

$data = @()

    while ($reader.read()){
        
        #on ajoute toutes les colones avec leur valeur dans un hashTable.
        $data += New-Object PSObject -property @{
            famille = $reader[0]
            codeActe = $reader[1]
            libelle = $reader[2]
            honoraires = [float]$reader[3]/10000
            typeActe="CCAM"
        }
    }
    
$reader.close()

#ACTES NGAP (consultation + ortho)
$cmd.CommandText = "select libellelong,codeacte,libelleacte,honoraireadulte,codedonnee  from tblparamactes INNER JOIN tblparamgeneraux ON tblparamgeneraux.codedonnee = tblparamactes.familledacte where coderegroupement = 'FMAC' and (codeacte = 'C' or familledacte in ('ORT','ADLT','ADUL','MOB','MB','ODFR','DIAG','HNO'));"
$reader = $cmd.ExecuteReader()
while ($reader.read()){
        
        #on ajoute toutes les colones avec leur valeur dans un hashTable.
        $data += New-Object PSObject -property @{
            famille = $reader[0]
            codeActe = $reader[1]
            libelle = $reader[2]
            honoraires = [float]$reader[3]/10000
            typeActe="NGAP"
        }


    }
$reader.close()
$DBConn.close()

$data |out-excel



