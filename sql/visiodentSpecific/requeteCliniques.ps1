[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
#############################################################################
##  Formulaire de selection 
#############################################################################
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Choisir une requete"
$objForm.Size = New-Object System.Drawing.Size(300,200) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$objListBox.SelectedItem;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$x=$objListBox.SelectedItem;$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(280,20) 
$objLabel.Text = "Please select a computer:"
$objForm.Controls.Add($objLabel) 

$objListBox = New-Object System.Windows.Forms.ListBox 
$objListBox.Location = New-Object System.Drawing.Size(10,40) 
$objListBox.Size = New-Object System.Drawing.Size(260,20) 
$objListBox.Height = 80
$objForm.Controls.Add($objListBox) 

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
#############################################################################
function Out-Excel

{

  param($Path = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv")

  $input | Export-CSV -Path $Path -UseCulture -Encoding UTF8 -NoTypeInformation

  Invoke-Item -Path $Path

}
#############################################################################

function showSelecteur($choix)
{
    $choix |foreach {[void] $objListBox.Items.Add($_)}

    $objForm.Controls.Add($objListBox) 

    $objForm.Topmost = $True

    $objForm.Add_Shown({$objForm.Activate()})
    [void] $objForm.ShowDialog()

    return $x
}

#############################################################################
##   MAIN 
#############################################################################
$cliniques = @(
    @{clinique = "caluire" ; serveur="w11690100snf"},
    @{clinique = "jet d'eau" ; serveur="w11690100sof"},
    @{clinique = "vilelfranche" ; serveur="w11690100spf"},
    @{clinique = "part dieu" ; serveur="w11690100sqf"},
    @{clinique = "villeurbanne" ; serveur="w11690100srf"},
    @{clinique = "saint fons" ; serveur="w11690100ssf"},
    @{clinique = "verdun" ; serveur="w11690100stf"}
    )
    
$data = @()  #le tableau des resultats.

#les requetes disponibles.
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

$choix = gci $scriptPath ".\requetes\*.sql"

if ($choix.getTYpe().Name -eq 'FileInfo'){
    $requete = get-content($choix)
}else{

    $reponse = showSelecteur($choix)

    if (!$reponse){#l'utilisateur n'as pas cliqué.
        $reponse=$choix[0]
    }

    $requete = get-content ($scriptPath + "\\requetes\\" +$reponse)
}

write-host "reponse = $reponse"


write-host $requete

foreach ($clinique in $cliniques){
    
    write-host($clinique.clinique)
    $MyServer = $clinique.serveur
    $Myport = 5434
    $MyDB = "visiodent"
    #$MyDB = "sesamvitale"
    $MyUid = "postgres"
    $MyPass = gc db.pass
    
    $DBConnectionString = "Driver={PostgreSQL ANSI};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
    $DBConn = New-Object System.Data.Odbc.OdbcConnection;
    $DBConn.ConnectionString = $DBConnectionString;
    $DBConn.Open();

    #exemple de query
    $cmd = $DBConn.CreateCommand()
    $cmd.commandText = $requete
    
    if ($cmd.commandText.length -lt 1){
        write-host("requette vide")
    }
    
    if ($cmd.commandText.length -like "select*"){
        write-host("requette select uniquement")
    }
    
    $reader = $cmd.ExecuteReader()

    #nom des colones
    $cols = @()
    for($i=0;$i -lt $reader.fieldCount ; $i++){
        write-debug("field {0} : {1}" -f $i,$reader.getName($i))
        $cols += $reader.getName($i)
    }

    #tableau de retour
    
    
    #prenons les données, pour en faire un PSObject
    while ($reader.read()){

        #on ajoute toutes les colones avec leur valeur dans un hashTable.
        $hash = @{}
        $hash.add("clinique",$clinique.clinique)
        
        for ($i=0;$i -lt $cols.length ; $i++){
            $hash.add($cols[$i],$reader[$i])
        }
        
        #on ajoute un PSobject au tableau.
        $data += New-Object PSObject -property $hash


    }

    $reader.close()
    $DBConn.close()
}

$data|out-excel
#$data|ogv