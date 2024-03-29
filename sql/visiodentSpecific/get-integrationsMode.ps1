<#####################################
creation des connexion
####################################>

$MyServer = "w11690100srf"
$Myport = 5434
$MyUid = "postgres"
$MyPass = gc db.pass

$MyDB = "visiodent"
$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"

$DBVisiodent = New-Object System.Data.Odbc.OdbcConnection;
$DBVisiodent.ConnectionString = $DBConnectionString;


$MyDB = "sesamvitale"
$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"

$DBSesam = New-Object System.Data.Odbc.OdbcConnection;
$DBSesam.ConnectionString = $DBConnectionString;




#requete
<#####################################
QuerySelect : execute une requete select sur la base de données spécifié
In : OdbcConnction $connexion
In : String $requete
Out : System.Data.DataTable 
####################################>

function querrySelect($connexion , $requete){
    
        $connexion.open()
        $cmd = $connexion.CreateCommand()
        $cmd.commandText = $requete
        $SqlAdapter = New-Object System.Data.Odbc.OdbcDataAdapter($cmd)
        $DataSet = New-Object System.Data.DataSet
        $nRecs = $SqlAdapter.Fill($DataSet)
    
    $connexion.close()
    return $dataset.Tables[0]
}

$facturesFaites = querrySelect $DBsesam "select numerofacture,numeroordrefacture from tblinfosfacture where nirps = '10003588919'"

$facturesPayees = querrySelect $DBVisiodent "select indexfacture,modereglement,montantpaye from tblactestxt_inforeglements where indexpraticien = 11"
$facturesPayees |group {$_.modereglement}


