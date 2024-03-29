#get-factureNonIntegre : 
# exporte les factures intégré dans les bases sesamvitales (table tblstructurersp) et visiodent (table tblretournoemie),
# puis liste les difference (a partir de la vue pointageRSP definie sur le serveur saf : 
# cette vue sert unique a realiser la jointure entre les deux table, sur numerofse = numFSE (table retournoemie) )
#
# exporte les données dans un fichier excel : 
#
#

#############################################################################
function Out-Excel

{

  param($Path = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv")

  $input | Export-CSV -Path $Path -UseCulture -Encoding UTF8 -NoTypeInformation

  Invoke-Item -Path $Path

}
#############################################################################

$donneesVisiodent = @()
$donneesSesamvitale = @()



##
##donneesVisiodent
##
$MyServer = "w11690100ssf"
$Myport = 5434
$MyDB = "visiodent"
$MyUid = "postgres"
$MyPass = gc db.pass

$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

#requete
$cmd = $DBConn.CreateCommand()

$cmd.commandText = @"
SELECT indexretournoemie, 
       typederetour, 
       nomfichierrsp, 
       numeroemetteur, 
       datenoemie, 
       numerolot, 
       numerofse, 
       datefse, 
       indexfacturevisio, 
       indexpatientvisio, 
       numeromatricule, 
       typedetraitement, 
       retourtraite, 
       retourtraitele, 
       information, 
       grandregime, 
       organismedestinataire, 
       centregestionnaire, 
       norme, 
       montantfichier, 
       destinataire, 
       montantdestinataire, 
       datecomptable, 
       montantdate, 
       datelot, 
       montantlot, 
       natureassurance, 
       montantreglement, 
       montantreglementro, 
       montantreglementrc, 
       montantreglements, 
       montantreglementp, 
       montantreglemento, 
       indexassurevisio
  FROM tblretournoemie where datelot > 42005
"@
# 42005 = 01/01/2015

$SqlAdapter = New-Object System.Data.Odbc.OdbcDataAdapter($cmd)
$DataSet = New-Object System.Data.DataSet
$nRecs = $SqlAdapter.Fill($DataSet)
write-host $nrecs "dans la table tblretournoemie depuis 01-01-2015"
$donneesVisiodent = $dataset.Tables[0]


$DBConn.Close();

#$Path1 = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv"
#$path1 = $folder + "tblretournoemie.csv"
#$donneesVisiodent | Export-CSV -Path $Path1 -UseCulture -Encoding UTF8 -NoTypeInformation
#Invoke-Item -Path $Path


##
##donneesSesamvitale
##
$MyDB = "sesamvitale"
$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

#requete
$cmd = $DBConn.CreateCommand()

$cmd.commandText = @"
SELECT idrsp
      ,numerofacture
      ,typefacture
      ,datefacturation
      ,numerolot
      ,nirsv
      ,etatpayementamo
      ,etatpayementamc
      ,montantamo
      ,montantamc
      ,montantfacture
      ,nirps
      ,libellerejet
      ,idretour
      ,emetteur
      ,datenaissance
      ,rangnaissance
      ,nom
      ,prenom
      ,datecomptable
      ,destinataire
      ,datedulot
  FROM tblstructurersp where datedulot >'2015-01-01'
"@

$SqlAdapter = New-Object System.Data.Odbc.OdbcDataAdapter($cmd)
$DataSet = New-Object System.Data.DataSet
$nRecs = $SqlAdapter.Fill($DataSet)
Write-host $nrecs "enregistrement dans la table tblstruturersp"
$donneesSesamvitale = $dataset.Tables[0]

$DBConn.Close();

#$Path2 = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv"
#$path2 = $folder + "tblstructurersp.csv"
#$donneesSesamvitale | Export-CSV -Path $Path2 -UseCulture -Encoding UTF8 -NoTypeInformation

$DBConnectionString = "Server=W11690100SAF;database=RSPcheck;Integrated security=True;"
#$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn = new-object System.Data.SqlClient.SqlConnection
$DBConn.ConnectionString = $DBConnectionString
$DBConn.Open();

$cmd = $DBConn.createCommand()

write-host "purge des tables MSSQL"
$cmd.commandText = "TRUNCATE TABLE dbo.tblretournoemie;"
$cmd.executeNonQuery()
$cmd.commandText = "TRUNCATE TABLE dbo.tblstructurersp;"
$cmd.executeNonQuery()
write-host "purge ok"


$bulkCopy = new-object System.data.sqlClient.SqlBulkCopy($DBConn)
$bulkcopy.bulkcopytimeout = 90

write-host "bulkCopy retournoemie"
$bulkCopy.DestinationTableName = "dbo.tblretournoemie"
$bulkCopy.WriteToserver($donneesVisiodent)

write-host "bulkCopy structureRSP"
$bulkCopy.DestinationTableName = "dbo.tblstructurersp"
$bulkCopy.WriteToserver($donneesSesamvitale)

write-host "conversion numerofacture en BIGINT"
$cmd.commandText = @"
update RSPcheck.dbo.tblstructurersp 
set numerofse = CAST (numerofacture as BIGINT) 
where ISNUMERIC(numerofacture) = 1
"@
$cmd.executeNonQuery()

write-host "recup des infos de la vue"
$cmd.commandText  = "select  numerofse
      ,numFSE
      ,etatpayementamo
      ,etatpayementamc
      ,typefacture
      ,numerolot
      ,nirsv
      ,montantamo
      ,montantamc
      ,montantfacture
      ,nirps
      ,libellerejet
      ,nom
      ,prenom
      ,datenaissance
      ,destinataire
      ,datedulot
      ,datefacturation
      FROM dbo.pointageRSP WHERE numFSE IS NULL";
      
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$DataSet = New-Object System.Data.DataSet
$nRecs = $SqlAdapter.Fill($DataSet)
$dataset.tables[0] |out-excel
$DBConn.Close();