##parametres :
#

$rdvDureeMax = 60


$cliniques = @(
    @{clinique = "caluire" ; serveur="w11690100snf"},
    @{clinique = "jet d'eau" ; serveur="w11690100sof"},
    @{clinique = "vilelfranche" ; serveur="w11690100spf"},
    @{clinique = "part dieu" ; serveur="w11690100sqf"},
    @{clinique = "villeurbanne" ; serveur="w11690100srf"},
    @{clinique = "saint fons" ; serveur="w11690100ssf"},
    @{clinique = "verdun" ; serveur="w11690100stf"}
    )

$data = @()


foreach ($clinique in $cliniques){
$MyServer = $clinique.serveur
$Myport = 5434
$MyDB = "sesamvitale"
$MyUid = "postgres"
$MyPass = gc db.pass



$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

$cmd = $DBConn.CreateCommand()

$cmd.commandText = @"
SELECT
numeroordrefacture,
datecreer,
isdesync,
nomps,
nomassure,
nombeneficaire,
datenaissance,
numeroimmatriculation,
montanthonoraires
FROM tblinfosfacture
WHERE isdesync = true;
"@

$reader = $cmd.ExecuteReader()



    while ($reader.read()){

        #on ajoute toutes les colones avec leur valeur dans un hashTable.
        $data += New-Object PSObject -property @{
            clinique = $clinique.clinique
            numeroordrefacture = $reader[0]
            datecreer = [dateTime]::parseExact($reader[1]/10000,"yyyyMMdd",$null)
            isdesync = $reader[2]
            nomps = $reader[3]
            nomassure = $reader[4]
            nombeneficaire = $reader[5]
            datenaissance = [dateTime]::parseExact($reader[6]/10000,"yyyyMMdd",$null)
            numeroimmatriculation = $reader[7]
            montanthonoraires = $reader[8]/100
        }


    }

$reader.close()
$DBConn.close()
}