##
##donneesVisiodent
##
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
$donneesvisiodent = $dataset.Tables[0]
$DBConn.Close();


##
##donneesSesamvitale
##
$MyDB = "sesamvitale"
$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DB2Conn = New-Object System.Data.Odbc.OdbcConnection;
$DBC2onn.ConnectionString = $DBConnectionString;
$DB2Conn.Open();

#requete
$cmd = $DB2Conn.CreateCommand()

$cmd.commandText = @"
select numerofacture,nom,prenom,montantfacture from tblstructurersp where etatpayementAMO = 'PAYE' or etatpayementAMC = 'PAYE'
"@

$SqlAdapter = New-Object System.Data.Odbc.OdbcDataAdapter($cmd)
$DataSet2 = New-Object System.Data.DataSet
$nRecs = $SqlAdapter.Fill($DataSet2)
$nrecs |out-null
$donneesSesamvitale = $dataset2.Tables[0]

$DB2Conn.Close();

###
### jointure des deux fichiers
###

$DBConnectionString = "Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq=\\w11690100suf\APP-ACCESS\FNI\Database1.accdb;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

$accessDataApadter = New-Object System.Data.Odbc.OdbcDataAdapter
$AccessDataSet = New-Object System.Data.DataSet

$AccessDataSet.tables.Add($donneesSesamvitale.copy());
$AccessDataSet.tables[0].TableName = "sesamvitale"

$AccessDataSet.tables.Add($donneesVisiodent.copy());
$AccessDataSet.tables[1].TableName = "visiodent"

$accessAdapter = New-Object System.Data.Odbc.OdbcDataAdapter

$cmdSel = $DB2Conn.CreateCommand()
$cmdSel.commandText = "select numerofacture,nom,prenom,montantfacture from tblstructurersp where etatpayementAMO = 'PAYE' or etatpayementAMC = 'PAYE'"

$cmdIns = $DBConn.CreateCommand()
$cmdIns.commandText = "INSERT into tblstructurersp (numerofacture,nom,prenom,montantfacture) VALUES (@numerofacture, @nom, @prenom, @montantfacture)"
$cmdIns.Parameters.add( (new-object system.data.ODBC.ODBCParameter("@numerofacture" , [system.data.odbc.odbcType]::Char , 9)))
$cmdIns.Parameters.add( (new-object system.data.ODBC.ODBCParameter("@nom",[system.data.odbc.odbcType]::NVarChar , 20)))
$cmdIns.Parameters.add( (new-object system.data.ODBC.ODBCParameter("@prenom",[system.data.odbc.odbcType]::NVarChar,20)))
$cmdIns.Parameters.add( (new-object system.data.ODBC.ODBCParameter("@montantfacture",[system.data.odbc.odbcType]::Double,4)))

$accessAdapter.InsertCommand = $cmdIns;
$accessAdapter.SelectCommand = $cmdSel;

$accessAdapter.AcceptChangesDuringFill = false;
$accessAdapter.Update($AccessDataSet,"sesamvitale")


$DBConn.close()