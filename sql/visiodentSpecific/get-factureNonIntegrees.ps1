#get-factureNonIntegre : 
# exporte les factures intégré dans les bases sesamvitales et visiodent,
# puis liste les difference
#

#join on csv
#https://social.msdn.microsoft.com/Forums/en-US/95d62bed-47ae-4e06-9327-a6a74f51b497/ado-with-text-files-problem-doing-join
#

$donneesVisiodent = @()
$donneesSesamvitale = @()
$folder = "D:\incoming\noemie\"


###############################################################################################
##donneesVisiodent
###############################################################################################
$MyServer = "s116901d0000085"
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
select numerofse,numerolot,indexpatientvisio from tblretournoemie
"@

$SqlAdapter = New-Object System.Data.Odbc.OdbcDataAdapter($cmd)
$DataSet = New-Object System.Data.DataSet
$nRecs = $SqlAdapter.Fill($DataSet)
$nrecs |out-null
$donneesVisiodent = $dataset.Tables[0]


$DBConn.Close();

#$Path1 = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv"
#$path1 = $folder + "tblretournoemie.csv"
#$donneesVisiodent | Export-CSV -Path $Path1 -UseCulture -Encoding UTF8 -NoTypeInformation
#Invoke-Item -Path $Path


###############################################################################################
##donneesSesamvitale
###############################################################################################

$MyDB = "sesamvitale"
$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

#requete
$cmd = $DBConn.CreateCommand()

$cmd.commandText = @"
select numerofacture,nom,prenom,montantfacture from tblstructurersp where etatpayementAMO = 'PAYE' or etatpayementAMC = 'PAYE'
"@

$SqlAdapter = New-Object System.Data.Odbc.OdbcDataAdapter($cmd)
$DataSet = New-Object System.Data.DataSet
$nRecs = $SqlAdapter.Fill($DataSet)
$nrecs |out-null
$donneesSesamvitale = $dataset.Tables[0]

$DBConn.Close();


###############################################################################################
## MS SQL
###############################################################################################


##Simple Tst 
$MyDB = "RSPCheck"
$DBConnectionString = "Server=W11690100SAF;database=RSPcheck;Integrated security=True;"
#$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn = new-object System.Data.SqlClient.SqlConnection
$DBConn.ConnectionString = $DBConnectionString
$DBConn.Open();

$cmd = $DBConn.createCommand()
$cmd.CommandText = "select count(*) from dbo.pointageRSP where numFSE is NULL and datedulot > '2015-01-01';"
$reader = $cmd.ExecuteReader()
$data2 = @()

while ($reader.read()){

    #on ajoute toutes les colones avec leur valeur dans un hashTable.
    $hash = @{}
    
    for ($i=0;$i -lt $cols.length ; $i++){
        $hash.add($cols[$i],$reader[$i])
    }
    
    #on ajoute un PSobject au tableau.
    $data2 += New-Object PSObject -property $hash

}

$DBConn.Close();
