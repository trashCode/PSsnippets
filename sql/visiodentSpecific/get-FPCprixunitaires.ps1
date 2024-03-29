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
$MyDB = "visiodent"
$MyUid = "postgres"
$MyPass = gc db.pass



$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

$cmd = $DBConn.CreateCommand()

$cmd.commandText = @"
SELECT 
plan,
indexacte,
indexpatient,
datedelacte,
codesecu,
indexfeuillehonoraire,
prixunitaire,
montant
FROM tblactesspo
WHERE codesecu = 'FDC' 
AND montant not in (1225000,2675000,5555000,7005000,4105000,8455000)
"@

$cmd.commandText = @"
select plan,indexacte,indexpatient,datedelacte,codesecu,indexfeuillehonoraire,prixunitaire/100 as pu ,montant/100 as mnt
from tblactesspo
where codesecu = 'FPC' and montant not in (1225000)
"@


$reader = $cmd.ExecuteReader()



    while ($reader.read()){

        #on ajoute toutes les colones avec leur valeur dans un hashTable.
        $data += New-Object PSObject -property @{
            clinique = $clinique.clinique
            plan = $reader[0]
            indexacte = $reader[1]
            indexpatient = $reader[2]
            datedelacte = $reader[3]
            codesecu = $reader[4]
            indexfeuillehonoraire = $reader[5]
            prixunitaire = $reader[6]/10000
            montant = $reader[7]/10000
        }


    }

$reader.close()
$DBConn.close()
}

$data |format-table