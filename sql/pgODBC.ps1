$MyServer = "S116901D0000085"
$Myport = 5434
$MyDB = "visiodent"
$MyDB = "sesamvitale"
$MyUid = "postgres"
$MyPass = gc db.pass

$DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();

#recuperation de la liste des tables.
$tables = $DBConn.getSchema('Tables')
$columns = $DBConn.getSchema('Columns') ##Long !!

#exemple de query
$cmd = $DBConn.CreateCommand()
$cmd.CommandText = "select count(*) from tblstructurersp where etatpayementAMO = 'PAYE' or etatpayementAMC = 'PAYE';"
#$cmd.CommandText = "select familledacte,codeacte,libelleacte from tblparamactes where codeacteCCAM != '';"
#$cmd.CommandText = "select cheminfichier from tblretours where typedemessage != 'ARL' and idretour = 34968;"
$reader = $cmd.ExecuteReader()


#exploitation du reader.
write-host("nombre de Fields du reader : {0}" -f $reader.FieldCount)

#nom des colones
$cols = @()
for($i=0;$i -lt $reader.fieldCount ; $i++){
    write-host("field {0} : {1}" -f $i,$reader.getName($i))
    $cols += $reader.getName($i)
}

#prenons les données, pour en faire un PSObject
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

$reader.close()
write-host("le reader est fermé ? : {0}" -f $reader.isclosed)


    
$DBConn.close()

#EOF