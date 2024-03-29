$dt2 = New-Object System.Data.Datatable "factures"
$dt2.Columns.Add("clinique")
$dt2.Columns.Add("dateFacture")
$dt2.Columns.Add("facture")
$dt2.Columns.Add("nir")
$dt2.Columns.Add("nom")
$dt2.Columns.Add("prenom")
$dt2.Columns.Add("praticien")
$dt2.Columns.Add("MntSoins")
$dt2.Columns.Add("MntProthese")
$dt2.Columns.Add("MntODF")
$dt2.Columns.Add("MntPatient")
$dt2.Columns.Add("MntRo")
$dt2.Columns.Add("MntRC")
$dt2.Columns.Add("regulAccompte")
$dt2.Columns.Add("organisme")
$dt2.Columns.Add("mutuelle")
$dt2.Columns.Add("Dossier")
$dt2.Columns.Add("patient")
$dt2.Columns.Add("cloture")
$dt2.Columns.Add("fse")

$factures | %{
    $row = $dt2.NewRow();
    
    $row["clinique"]=$_.clinique;
    $row["dateFacture"]=$_.dateFacture;
    $row["facture"]=$_.facture;
    $row["nir"]=$_.nir;
    $row["nom"]=$_.nom;
    $row["prenom"]=$_.prenom;
    $row["praticien"]=$_.praticien;
    $row["MntSoins"]=$_.MntSoins;
    $row["MntProthese"]=$_.MntProthese;
    $row["MntODF"]=$_.MntODF;
    $row["MntPatient"]=$_.MntPatient;
    $row["MntRo"]=$_.MntRo;
    $row["MntRC"]=$_.MntRC;
    $row["regulAccompte"]=$_.regulAccompte;
    $row["organisme"]=$_.organisme;
    $row["mutuelle"]=$_.mutuelle;
    $row["Dossier"]=$_.Dossier;
    $row["patient"]=$_.patient;
    $row["cloture"]=$_.cloture;
    $row["fse"]=$_.fse;
    
    $dt2.Rows.Add($row)
}


