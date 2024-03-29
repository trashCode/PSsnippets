function get-actesVisiodent($serveur){
    $MyServer = $serveur
    $Myport = 5434
    $MyDB = "visiodent"
    $MyUid = "postgres"
    $MyPass = gc db.pass

    $DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
    $DBConn = New-Object System.Data.Odbc.OdbcConnection;
    $DBConn.ConnectionString = $DBConnectionString;
    $DBConn.Open();

    #exemple de query
    $cmd = $DBConn.CreateCommand()
    $cmd.CommandText = "select familledacte,codeacte,libelleacte from tblparamactes where codeacteCCAM != '';"
    $cmd.CommandText = "select codeacte from tblparamactes where codeacteCCAM != '';"

    $reader = $cmd.ExecuteReader()


    #exploitation du reader.
    write-debug("nombre de Fields du reader : {0}" -f $reader.FieldCount)

    #nom des colones
    $cols = @()
    for($i=0;$i -lt $reader.fieldCount ; $i++){
        write-debug("field {0} : {1}" -f $i,$reader.getName($i))
        $cols += $reader.getName($i)
    }

    #prenons les données, pour en faire un PSObject
    $data = @()

    while ($reader.read()){

        #on ajoute toutes les colones avec leur valeur dans un hashTable.
        $hash = @{}
        
        for ($i=0;$i -lt $cols.length ; $i++){
            $hash.add($cols[$i],$reader[$i])
        }
        
        #on ajoute un PSobject au tableau.
        $data += New-Object PSObject -property $hash


    }

    $reader.close()
    write-debug("le reader est fermé ? : {0}" -f $reader.isclosed)


        
    $DBConn.close()

    return $data
}

$rs = @(@(),@(),@(),@(),@(),@(),@())
$serveurs = get-content "\\w11690100suf\source\serveursVisiodent.txt"

for($i = 0 ; $i -lt $serveurs.length ; $i++){
    $rs[$i] = get-actesVisiodent($serveurs[$i])
    write-host($serveurs[$i])
}