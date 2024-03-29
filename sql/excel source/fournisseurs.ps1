#updateDB prend du temps. 
#on n'effectue ceci qui si le fichier local est périmé.
#out : la liste des PSobject fournisseurs.
#
#TODO : dection auto du nombre de lignes !!
function updateDB($source){

    $excel = new-object -com excel.application
    #$excel.visible = $true

    $wb = $excel.workbooks.open($source)

    $sheet1 = $excel.Sheets.item(1)
    $sheet1.name
    $sheet1.Columns.count

    $nbLignes = 112
    $liste = @()
    for ($row = 3 ; $row -lt $nbLignes ; $row++){
            $sct = $sheet1.Cells.item($row,1).formula
            $nom = $sheet1.Cells.Item($row,2).formula
            $status = $sheet1.Cells.Item($row,3).formula
            $phone =  $sheet1.Cells.Item($row,4).formula
            $fax =  $sheet1.Cells.Item($row,5).formula
            $mail =  $sheet1.Cells.Item($row,6).formula
            $adresse =  $sheet1.Cells.Item($row,7).formula
            
            
            if ($sct.length -gt 0){$currentSCT = $sct}
            #debug
            #echo ($row.toString() + " " + $currentSCT + " " + $nom + " " + $status + " " + $phone + " " + $fax + " " + $mail + " " )
            $liste += New-Object -TypeName PSobject -Property @{ societe = $currentSCT; nom = $nom; status = $status ;phone = $phone ; fax = $fax ;mail = $mail ;adresse = $adresse} #ok !
            
    }

    
    $excel.quit()
    return $liste
}


#enregistrement de la liste sur le disque
#in : laliste, le chemin complet du fichier
#out : rien
function store($data , $path){
    $data |export-clixml $path
}

#charger liste depuis le disque
#in : le chemin de la liste a charger
#out : PSobject
function load($path){
    $rs =  import-clixml $path
    return $rs
}

#seek : rechecher un critere dans la liste.
function seek($liste, $critere){
    $critere = ("*{0}*" -f $critere)
    $rs = $liste |where {$_.societe -like $critere -or $_.nom -like $critere}
    return $rs
}

function displayResults($results){
    #init form
    add-type -AssemblyName System.windows.Forms
    $mainDesktopSize = [System.windows.Forms.screen]::PrimaryScreen.workingArea
    
    $form = new-object Windows.Forms.Form
    $form.Text = "Simple Form 1"
    $form.width = 520
    $form.height = 20
    
    #tentative de dimensionner le formulaire en fonction de son contenu. semble pas pris en compte ?
    #$form.clientSize.width = 384
    #$form.clientSize.height = 162
    
    #set Title
    if ($results.getType().Name -eq "PSCustomObject"){
        $form.Text = "1 resultat"
        #$form.height = 100
    }else{
        $form.Text = ("{0} resultats" -f $results.count)
        #$form.height = [Math]::min( ($results.count * 80)+20 , 620 )
        
    }    
    
   
    
    #Masque les boutons de titleNBar
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $False
    
    #ajout d'un layout
    $flowLayoutPanel = new-object System.Windows.Forms.FlowLayoutPanel
    $flowLayoutPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown #de haut en bas
    $form.Controls.Add($flowLayoutPanel)
    $flowLayoutPanel.Dock = [System.windows.Forms.DockStyle]::Fill #le panel prend tout le formulaire
    
    #this.FlowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
    #this.FlowLayoutPanel1.FlowDirection = FlowDirection.TopDown;
    #this.FlowLayoutPanel1.Controls.Add(this.Button1);
	#this.FlowLayoutPanel1.Controls.Add(this.Button2);
	#this.FlowLayoutPanel1.Controls.Add(this.Button3);
        
    #this.Controls.Add(this.FlowLayoutPanel1);
    if (!$results){
        $font = new-object system.Drawing.Font("Lucida console",16);
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = "Aucun resultat"
        $label.font = $font;
        $Label.AutoSize = $True
        $flowLayoutPanel.Controls.Add($Label)
        $form.height += 30
    }
        
    #Ajout des labels
    $results |foreach {
    
        $font = new-object system.Drawing.Font("Lucida console",16);
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = ($_.societe  -replace "\n",' ')+ " > " + $_.nom
        $label.font = $font;
        $Label.AutoSize = $True
        $flowLayoutPanel.Controls.Add($Label)
        
        #$font = new-object system.Drawing.Font("Lucida console",12);
        #$Label = New-Object System.Windows.Forms.Label
        #$Label.Text = $_.nom
        #$label.font = $font;
        #$Label.AutoSize = $True
        #$flowLayoutPanel.Controls.Add($Label)
        
        if ($_.phone){
            $font = new-object system.Drawing.Font("Lucida console",12);
            $Label = New-Object System.Windows.Forms.Label
            $Label.Text = $_.phone
            $label.font = $font;
            $Label.AutoSize = $True
            $flowLayoutPanel.Controls.Add($Label)
            
            $form.height += 20
        }
                
        if ($_.fax){
            $font = new-object system.Drawing.Font("Lucida console",12);
            $Label = New-Object System.Windows.Forms.Label
            $Label.Text = $_.fax
            $label.font = $font;
            $Label.AutoSize = $True
            $flowLayoutPanel.Controls.Add($Label)
            
            $form.height += 20
        }
        
        $form.height += 50
    
    }
    
    $flowLayoutpanel.wrapContents = $false #une seul colone pour les resultats
    $flowLayoutpanel.autoscroll = $true #scroller les resultat si trop nombreux
    
    
    #positionnement (coin bas gauche)
    $x = $mainDesktopSize.width - $form.width
    $y = $mainDesktopSize.height - $form.height
    $form.setDesktopLocation($x,$y);
    $form.startposition = [System.windows.Forms.FormStartPosition]::Manual

    #afficher
    $form.ShowDialog()
    
}

################################################
## MAIN
################################################
#$args = @('rPEUGEOT') ##debug : pour utilisation ISE

$path = "C:\Users\FANTON-21126\Documents\powershell snipets\sql\excel source\fournisseurs.xml"
$source = "\\w11690100suf\ADMINISTRATIF\99 - COMMUN\03 - ORGANISATION ADM\02 - ANNUAIRES\ANNUAIRE PRESTATAIRES EXTERNES.xls"

if (test-path $path){
    $liste = load($path)
}else{
    $liste = updateDB($source)
    store $liste $path 
}

$rs = seek $liste $args[0]
displayResults($rs)

#debug
#$rs |select-object -Property societe,nom,status,phone,fax|format-table

#si fichier périmé, pour la prochaine fois :
$local = (gci -Path $Path).LastWriteTime
$remote =(gci -Path $source).LastWriteTime
 
if($local -lt $remote){
    #fichier perimé : mise a jour !
    $liste = updateDB($source)
    store $liste $path 
}else{
    #rien :)
}
