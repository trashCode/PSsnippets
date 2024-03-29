function flushDB(){
    
    $storage =  "D:\PIF.accdb"
    $DBConnectionString =  "Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq=$storage;"
    $DBConn = New-Object System.Data.Odbc.OdbcConnection;
    $DBConn.ConnectionString = $DBConnectionString;
    $DBConn.Open();
    
    $cmd = $DBConn.createcommand()
    $cmd.commandtext = "DELETE * from operation"
    $cmd.ExecuteNonQuery()
    
    $DBConn.Close();
}#end flushDB

<#
commande de creation
$cmd.CommandText = @'
        CREATE TABLE operation (
            clinique NUMERIC,
            dateFacture DATE,
            facture VARCHAR(50),
            nir VARCHAR(50),
            nom VARCHAR(50),
            prenom VARCHAR(50),
            MntSoins NUMERIC,
            MntProthese NUMERIC,
            MntODF NUMERIC,
            MntPatient NUMERIC,
            MntRo NUMERIC,
            MntRC NUMERIC,
            regulAccompte NUMERIC,
            organisme VARCHAR(50),
            mutuelle VARCHAR(50),
            Dossier NUMERIC,
            patient VARCHAR(50),
            cloture VARCHAR(50),
            fse VARCHAR(50),
            filePath VARCHAR(80)
        );
'@
#>

<#
Importation des données de clotures (16k lignes)
#>
$files = gci -recurse "\\w11690100suf\clotures\verdun\" -filter "Ffactur*"
$delimiter = ';'
$header =  "clinique" , "dateFacture" , "facture" , "nir" , "nom" , "prenom" , "praticien" , "MntSoins" , "MntProthese" , "MntODF" , "MntPatient" , "MntRo" , "MntRC" , "regulAccompte" , "organisme" , "mutuelle" , "Dossier" , "patient" , "cloture" , "fse"

#parsing 
$operations = @()
$factures = @()
$annulations = @()
#$files |foreach {$factures += import-csv $_.fullname -delimiter $delimiter -header $header}
$files |foreach {
    $facture = import-csv $_.fullname -delimiter $delimiter -header $header;
    $facture | Add-Member -type noteProperty  -Name filePath -Value $_.fullName;
    
    $operations += $facture
    
}

#Conversion Int32 des montant (en centimes)
$s = get-date
$operations |foreach {
    $_.clinique = [Int32]$_.clinique;
    $_.MntSoins = [Int32]$_.MntSoins;
    $_.MntProthese = [Int32]$_.MntProthese;
    $_.MntODF = [Int32]$_.MntODF;
    $_.MntPatient = [Int32]$_.MntPatient;
    $_.MntRo = [Int32]$_.MntRo;
    $_.MntRc = [Int32]$_.MntRc;
    $_.regulAccompte = [Int32]$_.regulAccompte;
    $_.dossier = [Int32]$_.dossier;
    
    if ($_.MntSoins -lt 0 -or $_.MntProthese -lt 0 -or $_.MntODF -lt 0){
        $annulations += $_
    }else{
        $factures+=$_
    }
}
$e = get-date
write-host("La conversion string => int prend : {0:#.###}s" -f ($e-$s).totalSeconds)

<#
step 0 : conversion en datatable
#>
$s = get-date

$dt = New-Object System.Data.Datatable "MyTableName"
$dt.Columns.Add("clinique",[int32])
$dt.Columns.Add("dateFacture")
$dt.Columns.Add("facture")
$dt.Columns.Add("nir")
$dt.Columns.Add("nom")
$dt.Columns.Add("prenom")
$dt.Columns.Add("MntSoins",[int32])
$dt.Columns.Add("MntProthese",[int32])
$dt.Columns.Add("MntODF",[int32])
$dt.Columns.Add("MntPatient",[int32])
$dt.Columns.Add("MntRo",[int32])
$dt.Columns.Add("MntRC",[int32])
$dt.Columns.Add("regulAccompte",[int32])
$dt.Columns.Add("organisme")
$dt.Columns.Add("mutuelle")
$dt.Columns.Add("Dossier",[int32])
$dt.Columns.Add("patient")
$dt.Columns.Add("cloture")
$dt.Columns.Add("fse")
$dt.Columns.Add("filePath")

$factures |foreach {
    $row = $dt.NewRow();
    $row["clinique"] = $_.clinique;
    $row["dateFacture"] = $_.dateFacture;
    $row["facture"] = $_.facture;
    $row["nir"] = $_.nir;
    $row["nom"] = $_.nom;
    $row["prenom"] = $_.prenom;
    $row["MntSoins"] = $_.MntSoins;
    $row["MntProthese"] = $_.MntProthese;
    $row["MntODF"] = $_.MntODF;
    $row["MntPatient"] = $_.MntPatient;
    $row["MntRo"] = $_.MntRo;
    $row["MntRC"] = $_.MntRC;
    $row["regulAccompte"] = $_.regulAccompte;
    $row["organisme"] = $_.organisme;
    $row["mutuelle"] = $_.mutuelle;
    $row["Dossier"] = $_.Dossier;
    $row["patient"] = $_.patient;
    $row["cloture"] = $_.cloture;
    $row["fse"] = $_.fse;
    $row["filePath"] = $_.filePath;
    $dt.Rows.Add($row)
}

$e = get-date
write-host("La conversion en datatable prend : {0:#.###}s" -f ($e-$s).totalSeconds)

<#
Methode 1 : ADODB
#>


<#
Methode 2 : ODBC
#>


<#
Methode 3 : OleDB
lister les providers : 
(New-Object system.data.oledb.oledbenumerator).GetElements()
#>
$s = get-date
$conn = new-object System.Data.OleDB.OleDBConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D:\PIF.accdb;Persist Security Info=False;")
#$OleDBConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D:\PIF.accdb;Persist Security Info=False;"
#$conn.ConnectionString = $OleDBConnectionString

$selectCommand = @"
SELECT
clinique,
dateFacture,
facture,
nir,
nom,
prenom,
MntSoins,
MntProthese,
MntODF,
MntPatient,
MntRo,
MntRC,
regulAccompte,
organisme,
mutuelle,
Dossier,
patient,
cloture,
fse,
filePath
FROM operation;
"@

$adapter = new-object System.Data.OleDB.OleDBDataAdapter($selectCommand, $conn )
$cbr = new-object  System.Data.OleDB.OleDbCommandBuilder($adapter)

$cbr.getInsertCommand()

$conn.open()
$adapter.update($dt)
$conn.close()
$e = get-date
write-host("Insertion avec OleDBAdapter : {0:#.###}s" -f ($e-$s).totalSeconds)


<#
Recherche des doublon (factures annulé / vrai doublon)

$quieryAdapter.Fill Remplit le dataset, qui contient une collection de datatable.
$resultSet.tables[0].clear() pour purger 
#>
$s = get-date
$resultSet  = New-Object System.Data.DataSet
$query = "SELECT facture,count(*) as nb FROM operation GROUP BY facture HAVING (count(*) > 1)"
$queryAdapter = New-Object System.Data.OleDB.OleDBDataAdapter($query,$conn)
$conn.open()
$nbLines = $queryAdapter.Fill($resultSet)
$conn.close()

$e = get-date
write-host("Group by (recheche doublon): {0:#.###}s" -f ($e-$s).totalSeconds)


<#
Volume facture par praticiens

$quieryAdapter.Fill Remplit le dataset, qui contient une collection de datatable.
$resultSet.tables[0].clear() pour purger 
#>
$s = get-date
$resultSet  = New-Object System.Data.DataSet
#$query = "SELECT mid(facture,1,3) , count(*) as nb FROM operation GROUP BY mid(facture,1,3)"
$query = "SELECT mid(facture,1,3) as prat , MONTH(dateFacture) as mois,count(*) as nb FROM operation GROUP BY mid(facture,1,3),MONTH(dateFacture)"
$queryAdapter = New-Object System.Data.OleDB.OleDBDataAdapter($query,$conn)
$conn.open()
$nbLines = $queryAdapter.Fill($resultSet)
$conn.close()

$e = get-date
write-host("Group by (recheche doublon): {0:#.###}s" -f ($e-$s).totalSeconds)
