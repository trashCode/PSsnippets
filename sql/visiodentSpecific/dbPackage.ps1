



function flushTable($table,$connexion){
    if ($connexion.state -eq "Closed"){
        $connexion.open()
    }
    $cmd = $connexion.CreateCommand()
    $cmd.commandText = "delete from $table;"
    $cmd.executeNonQuery
    $connexion.close()
}

function getDataSet($requete,$connexion){
    #Execute une requete SELECT, renvois un dataset
    if ($connexion.state -eq "Closed"){
        $connexion.open()
    }
    $cmd = $connexion.CreateCommand()
    $cmd.commandText = $requete
    
    $SqlAdapter = New-Object System.Data.Odbc.OdbcDataAdapter($cmd)
    $DataSet = New-Object System.Data.DataSet
    $nRecs = $SqlAdapter.Fill($DataSet)
    $nrecs |out-null
    return $dataset;
}



function sendData($dataSet, $connexion, $tableName){
    ##TODO
}



$MyServer = "s116901d0000085"
$Myport = 5434
$MyUid = "postgres"
$MyPass = gc db.pass
$MyDB = "sesamvitale"
$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;

$query = "SELECT count(*) FROM tblstruturersp;"
$ds = getDataSet($query,$DBConn)