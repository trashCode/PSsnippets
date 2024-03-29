$MyServer = "s116901d0000085"
$Myport = 5434
$MyUid = "postgres"
$MyPass = gc db.pass

$MyDB = "sesamvitale"
$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBsource = New-Object System.Data.Odbc.OdbcConnection;
$DBsource.ConnectionString = $DBConnectionString;
$DBsource.Open();

$DBConnectionString = "Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq=\\w11690100suf\APP-ACCESS\FNI\Database1.accdb;"
$DBDest = New-Object System.Data.Odbc.OdbcConnection;
$DBDest.ConnectionString = $DBConnectionString;
$DBDest.Open();

$cmdSel = $DBsource.CreateCommand()
$cmdSel.commandText = "select numerofacture,nom,prenom,montantfacture from tblstructurersp where etatpayementAMO = 'PAYE' or etatpayementAMC = 'PAYE'"

$cmdIns = $DBDest.CreateCommand()
$cmdIns.commandText = "INSERT into tblstructurersp (numerofacture,nom,prenom,montantfacture) VALUES (@numerofacture, @nom, @prenom, @montantfacture)"
$cmdIns.Parameters.add( (new-object system.data.ODBC.ODBCParameter("@numerofacture" , [system.data.odbc.odbcType]::Char , 9, "numerofacture")))
$cmdIns.Parameters.add( (new-object system.data.ODBC.ODBCParameter("@nom",[system.data.odbc.odbcType]::NVarChar , 20 , "nom")))
$cmdIns.Parameters.add( (new-object system.data.ODBC.ODBCParameter("@prenom",[system.data.odbc.odbcType]::NVarChar,20 ,"prenom")))
$cmdIns.Parameters.add( (new-object system.data.ODBC.ODBCParameter("@montantfacture",[system.data.odbc.odbcType]::Double,4,"montantfacture")))

$dataAdapter = New-Object System.Data.Odbc.OdbcDataAdapter
$dataAdapter.insertCommand = $cmdIns
$dataAdapter.selectCommand = $cmdsel
$dataAdapter.AcceptChangesDuringFill = $false;


$dataSet = New-Object System.Data.DataSet

$dataAdapter.Fill($dataset,"tblstructurersp")

$dataAdapter.Update($dataset)


