function rechercheParNom($nom){
    if ($nom -eq "") {$nom = "chopelet"}
    $web = New-Object Net.WebClient
    $url = 'http://iapanr.cnamts.fr:7290/iapanr/ajaxRechercheAgent.do?displayname=*' +$nom + '*'
   
    $content = $web.DownloadString($url)
    
    #suppression des nbsp inutiles
    $content = $content.Replace("&nbsp;"," ")
    
    #correction des balises <img>
    $content = $content -replace '<img ([^>]+)>','<img $1 />'
    
    #conversion xml
    $xml = [xml]$content
    
    ##
    $liste = @()

    for ($i =0 ;$i -lt $xml.table.tr.count ; $i++){
    
        if ($i -gt 0){#ligne 0 = entete, on ignore.
        
        $detail = $xml.table.tr[$i].td[0].a.href #lien vers page detail de la personne
        if ($detail) {$detail = 'http://iapanr.cnamts.fr:7290' + $detail}
        
        $nom = $xml.table.tr[$i].td[0].a.i #nom
        $organisme = $xml.table.tr[$i].td[1].a.'#text'   #organisme
        $site = $xml.table.tr[$i].td[2].a.'#text'   #site
        $entite = $xml.table.tr[$i].td[3].a."#text"   #entitée
        
        $mail = $xml.table.tr[$i].td[5].center.a.href #mail
        if ($mail) {$mail = $mail.substring(7,$mail.length-7)}
        
        $telephone = $xml.table.tr[$i].td[6] #téléphone
        if ($telephone) {$telephone = ($telephone -replace '\n','').trim() ; $telephone = displayPhoneNumber($telephone) }
        
        $liste += New-Object -TypeName PSobject -Property @{ nom = $nom; organisme = $organisme; site = $site ;entite = $entite ; mail = $mail ;telephone = $telephone ;detail = $detail} #ok !
        }
    }
    return $liste
}

function getMobilePhone($ie,$uri){
    ## le html de cette page est pourri (moultes malformation, trop de travail)
    ## Une bonne alternative semble $ie.Navigate, semble lente !
    ## alternative non out-of-the-box Html Agility Pack
    
    $ie.Navigate($uri)
    $ie.document |out-null
    $ie.document.body |out-null
    
    do { sleep -Milliseconds 40 } 
    while($ie.Busy)
    
    $text = $ie.document.body.innerText #ne marche pas ?!
    
    $mobile = [regex]::Match($text, 'Mobile :([0-9 ]+)')
    if ($mobile.success){
        $mobile = $mobile.Value.substring(9)
    }else{
        $mobile = ''
    }

    
    $site = [regex]::Match($text, 'Site Principal  : .+')
    if ($site.success){$site = $site.Value.substring(18)} else {$site = ''}
    
    $emploi = [regex]::Match($text, 'Libellé emploi : .+')
    if ($emploi.success){$emploi = $emploi.Value.substring(17)} else {$emploi = ''}
    
    $superieur = [regex]::Match($text, 'Supérieur hiérarchique direct : .+')
    if ($superieur.success){$superieur = $superieur.Value.substring(32)} else {$superieur = ''}
    
    $numAgent = [regex]::Match($text, 'Numéro agent : [0-9 ]+')
    if ($numAgent.success){$numAgent = $numAgent.Value.substring(15)} else {$numAgent = ''}
    
    $details = New-Object -TypeName PSobject -Property @{ numAgent = $numAgent; mobile = $mobile; site = $site ;emploi = $emploi ; superieur = $superieur} #ok !
    return $details
}

function displayPhoneNumber($phone){
    $phone = $phone.toString()
    $rs =""
    for($i = 0 ; $i -lt $phone.length ;$i++){
        $rs += $phone[$i]
        if ($i%2 -eq 1){$rs+=" "}
    }
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
        $form.Text = "Aucun resultat"
        $label.font = $font;
        $Label.AutoSize = $True
        $flowLayoutPanel.Controls.Add($Label)
        $form.height += 30
    }
    
    #Ajout des labels
    $results |foreach {
		
		if ($_.numAgent -ne ""){
			$_.numAgent = " (" + $_.numAgent + ")"
		}
		
        $font = new-object system.Drawing.Font("Lucida console",16);
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $_.nom + $_.numAgent
        $label.font = $font;
        $Label.AutoSize = $True
        $flowLayoutPanel.Controls.Add($Label)
        
        $font = new-object system.Drawing.Font("Lucida console",12);
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $_.telephone
        $label.font = $font;
        $Label.AutoSize = $True
        $flowLayoutPanel.Controls.Add($Label)
        
        if ($_.mobile){
            $font = new-object system.Drawing.Font("Lucida console",12);
            $Label = New-Object System.Windows.Forms.Label
            $Label.Text = $_.mobile
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
#######################################
##MAIN##
#######################################
#$args = @('fanton') ##debug : pour utilisation ISE
if ($args.length -gt 0){
    $liste = rechercheParNom($args[0])
	$detailed = $true #on ajoute le numero agent et le portable (ajoute une requette http par agent)
	
    $ie= new-object -com InternetExplorer.Application

    $reduite = $liste |where {$_.organisme -eq "Caisse Primaire d'Assurance Maladie du Rhone"}
    #$reduite = $liste
    
    if ($reduite -and $detailed){
        
        $reduite |foreach {
           if ($reduite.count -le 10){ #ne pas prendre les details si plus de 10 resultats
               $det = getMobilePhone $ie $_.detail
               $_ |add-member -type noteProperty  -Name mobile -Value $det.mobile
               $_ |add-member -type noteProperty  -Name numAgent -Value $det.numAgent
            }
        }
        
        $reduite |select nom,site,telephone,mobile,entite
        displayResults($reduite)
            
    }else{
        displayResults($reduite)
    }
    
    $ie.quit()
    

}

