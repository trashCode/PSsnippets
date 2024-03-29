##parametres :
#
$rdvDepuis = 42005 #date du 01/01/2015
$praticient = "'GINDRE'"




$data = @()
$MyServer = "w11690100snf"
$Myport = 5434
$MyDB = "visiodent"
$MyUid = "postgres"
$MyPass = gc db.pass

$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

$cmd = $DBConn.CreateCommand()

#Requete : 
# on recupere le nom du praticien a partir de la table tblpraticien
# les données sont dans plusieures tables :
#     tblAgenda
#     tblmemoagenda (commentaire principalement)
#     tblagenda_infordv (coordonnées patient deja rapatriées)


$cmd.CommandText = @"
SELECT tblagenda.indexrdv,
    datedurdv,
    heuredurdv,
    nompraticien,
    prenompraticien,
    fauteuil,
    duree,
    tblmemoagenda.commentaire as commentaire1,
    tblagenda_infordv.commentaire as commentaire2,
    tblagenda.indexpatient,
    nomPatient,
    prenomPatient 
FROM 
    tblagenda 
INNER JOIN tblpraticiens ON tblpraticiens.indexpraticien = tblagenda.indexpraticien 
LEFT OUTER JOIN tblmemoagenda on tblagenda.indexrdv = tblmemoagenda.indexagenda 
LEFT OUTER JOIN tblagenda_infordv on tblagenda.indexrdv = tblagenda_infordv.indexrdv
WHERE datedurdv > $rdvDepuis  
ORDER BY datedurdv,nompraticien;
"@

$reader = $cmd.ExecuteReader()


while ($reader.read()){

    #on ajoute toutes les colones avec leur valeur dans un PSObject.
    $data += New-Object PSObject -property @{
        indexrdv = $reader[0]
        date = $reader[1]
        heure = $reader[2]
        nompraticien = $reader[3]
        prenompraticien = $reader[4]
        fauteuil = $reader[5]
        duree = $reader[6]
        commentaire1 = $reader[7]
        commentaire2 = $reader[8]
        indexpatient = $reader[9]
        nompatient = $reader[10]
        prenomPatient = $reader[11]
    }

}

$reader.close()
$DBConn.close()

function convert-date($nbDays){
    return (get-date("30/12/1899")).addDays($nbDays)
}

function convert-heure($nbSeconds){
    $h = [Int32]($nbseconds/3600)
    $m = ($nbseconds%3600)/60
    
    return ("{0:00}:{1:00}" -f $h , $m)
}


function Out-Excel

{

  param($Path = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv")

  $input | Export-CSV -Path $Path -UseCulture -Encoding UTF8 -NoTypeInformation

  Invoke-Item -Path $Path

}


$data |foreach {
    $_.date = convert-date($_.date);
    $_.heure = convert-heure($_.heure)
}

$data|out-excel