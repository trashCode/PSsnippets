function ConvertInt2Date{
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int]$date

    )
    return (get-date("30/12/1899")).addDays($date)
}

function ConvertInt2Date{
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int]$date,
        
        [int]$hour

    )
    return (get-date("30/12/1899")).addDays($date).addseconds($hour)
}


##parametres :
#
$rdvDepuis = 42005 #date du 01/01/2015
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
$clinique = $cliniques[6]

#foreach ($clinique in $cliniques){
$MyServer = "w11690100stf"
$Myport = 5434
$MyDB = "visiodent"
$MyUid = "postgres"
$MyPass = gc db.pass

$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

$cmd = $DBConn.CreateCommand()
$cmd.CommandText = "select indexrdv,datedurdv,heuredurdv,nompraticien,prenompraticien,fauteuil,duree,commentaire from tblagenda INNER JOIN tblpraticiens ON tblpraticiens.indexpraticien = tblagenda.indexpraticien LEFT OUTER JOIN tblmemoagenda on tblagenda.indexrdv = tblmemoagenda.indexagenda where indexpatient = 0 and duree < $rdvDureeMax  and datedurdv > $rdvDepuis order by datedurdv,nompraticien;"
$reader = $cmd.ExecuteReader()



while ($reader.read()){

    #on ajoute toutes les colones avec leur valeur dans un hashTable.
    $data += New-Object PSObject -property @{
        clinique = $clinique.clinique
        indexrdv = $reader[0]
        date = convertInt2date $reader[1] $reader[2]
        nompraticien = $reader[3]
        prenompraticien = $reader[4]
        fauteuil = $reader[5]
        duree = $reader[6]
        commentaire = $reader[7]
    }


}

$reader.close()
$DBConn.close()
#}



