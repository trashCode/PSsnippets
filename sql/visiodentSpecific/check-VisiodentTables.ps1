$serveurs = get-content "\\w11690100suf\source\serveursVisiodent.txt"

$Globaltables = @()

foreach ($serveur in $serveurs){

$MyServer = $serveur
$Myport = 5434
$MyDB = "visiodent"
$MyUid = "postgres"
$MyPass = gc db.pass

$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();
write-debug("$serveur")

#recuperation de la liste des tables.
$tables = $DBConn.getSchema('Tables')
$rs = @()

##transformation en array
for ($i=0 ; $i -lt $tables.rows.count ; $i++){
    $rs += ,$tables.rows[$i].TABLE_NAME
}
$GlobalTables += ,$rs

$DBConn.close()
}



Write-host "==== comparaisons ==="

for($i=0 ; $i -lt $serveurs.length ; $i++){
    write-host($serveurs[$i])
    (diff $globalTables[0] $globalTables[1]) |where-object {$_.InputObject -notmatch '.[0-9][0-9][0-9]'}
}