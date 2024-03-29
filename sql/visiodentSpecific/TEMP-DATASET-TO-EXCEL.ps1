##parametres :
#
$rdvDepuis = 42005 #date du 01/01/2015
$rdvDureeMax = 60
$exportPath = $HOME 


$cliniques = @(
    @{clinique = "caluire" ; serveur="w11690100snf"},
    @{clinique = "jet d eau" ; serveur="w11690100sof"},
    @{clinique = "vilelfranche" ; serveur="w11690100spf"},
    @{clinique = "part dieu" ; serveur="w11690100sqf"},
    @{clinique = "villeurbanne" ; serveur="w11690100srf"},
    @{clinique = "saint fons" ; serveur="w11690100ssf"},
    @{clinique = "verdun" ; serveur="w11690100stf"}
    )

$data = @()
$MasterDataSet = new-object system.data.dataset
$clinique = $cliniques[6]

foreach ($clinique in $cliniques){
write-host("connexion a {0}" -f $clinique.clinique)
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
$cliniqueName = $clinique.clinique
$cmd.CommandText = "select '$cliniqueName' as clinique,indexrdv,datedurdv,heuredurdv,nompraticien,prenompraticien,fauteuil,duree,commentaire from tblagenda INNER JOIN tblpraticiens ON tblpraticiens.indexpraticien = tblagenda.indexpraticien LEFT OUTER JOIN tblmemoagenda on tblagenda.indexrdv = tblmemoagenda.indexagenda where indexpatient = 0 and duree < $rdvDureeMax  and datedurdv > $rdvDepuis and datedurdv < 65535 order by datedurdv,nompraticien;"

#requette avec conversion date
#$cmd.CommandText = "select '$cliniqueName' as clinique,indexrdv,(DATE '1900-01-01' + dateduRDV::integer - 2) as datedurdv,heuredurdv,nompraticien,prenompraticien,fauteuil,duree,commentaire from tblagenda INNER JOIN tblpraticiens ON tblpraticiens.indexpraticien = tblagenda.indexpraticien LEFT OUTER JOIN tblmemoagenda on tblagenda.indexrdv = tblmemoagenda.indexagenda where indexpatient = 0 and duree < $rdvDureeMax  and datedurdv > $rdvDepuis and datedurdv < 65535 order by datedurdv,nompraticien;"

$ODBCadapter = new-object System.Data.Odbc.OdbcDataAdapter
$ODBCadapter.selectCommand = $cmd
$dataset = new-object system.data.dataset

$ODBCAdapter.fill($dataset)

$MasterDataSet.merge($dataSet)


$DBConn.close()
}

#Ajout de deux colones pour dateRDV et heureRDV lisibles
$d = get-date("01-01-1900")
$table = $masterdataset.Tables[0]

$col1 = new-object data.datacolumn
$col1.ColumnName = "dateRDV"
$table.columns.add($col1)
#Abandoné : excel gere mieux les dates dans son format natif.

$col2 = new-object data.datacolumn
$col2.ColumnName = "heureRDV"
$table.columns.add($col2)
$table.columns['heureRDV'].setOrdinal(3)

for ($i=0 ; $i -lt $table.rows.count ; $i++){
    $table.Rows[$i]["dateRDV"] = $d.addDays($table.rows[$i]["datedurdv"] -2).toString("dd/MM/yyyy")
    $table.Rows[$i]["heureRDV"] = "{0}:{1}" -f ($table.rows[$i]["heuredurdv"]/3600).toString("00") , ($table.rows[$i]["heuredurdv"]%3600/60).toString("00")
    if ($i%100 -eq 0){$i}
}
$table.columns.remove("heuredurdv")
$filePath = "{0}\Desktop\{1}.xml" -f $exportPath,'ZoneReservees'
$MasterDataSet.writeXml($filePath)


