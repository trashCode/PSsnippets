##
##parse-RSP :
##Objectif : fournir un command-let qui ouvre un fichier RSP, et renvois un tableau 
##des informations contenues dedans.




##
## 1: le fichier est encodé dans la norme NOEMIE PS.
## il est composé d'entitée (champs a longueure fixe) délimitée par des "@".
##o

#$args[0] -eq "listref"
$path = "D:\WVISIO32\data\basecommune\retours\RSP\"
if ($args[0] -eq "listref"){
    $files = gci $path "*.rsp"
    $references = $files |foreach {(get-content $_.Fullname).substring(61,3)}|select -uniq ##c'est la referente? ?
    
}
#
#reference possibles : 576 , 900 , 531 , 572 , 603
#references du catalogues NOEMIE PS :
#
#    references pour le retour de paiement :
#    531 , 534 ; 536 , 572 , 573 , 576 ,577 , 578 , 580 , 603 , 613 

#   references de rejet
#900 : REJET
#908 : specifique Hopitaux publics

# references ARL
#930


$file = "D:\WVISIO32\data\basecommune\retours\RSP\retour_20150425084543089.rsp" #exemple de fichier ref 576
$content = get-content $file
$fileRef = $content.substring(61,4)
$table = $content.split("@")

#afficher grossierement le fichier
for ($i = 0 ; $i -lt $table.count ; $i++){
    write-host("{0} : {1} : {2}" -f $i, $table[$i].substring(3 , 2) , $table[$i].substring(0, [Math]::min(80,$table[$i].length) ) )
}



#scinder le fichier en ligne (n° ligne, niveau , entite , data)
$liste = @()
for ($i = 0 ; $i -lt $table.count ; $i++){
    $entite = $table[$i].substring(0,3)
    
    if ($entite -ne "000" -and $entite -ne "999"){
        $niveau = $table[$i].substring(3,2)
        $data = $table[$i].substring(5 , $table[$i].length - 5)
    }else{
        $niveau = "01"
        $data = $table[$i].substring(3 , $table[$i].length - 5)
    }
    
    
    $liste += New-Object -TypeName PSobject -Property @{ numero = $i; niveau = $niveau ; entite = $entite ; data = $data} #ok !
}

#ajout des infos utiles
$liste|foreach{
    
    $current = $_
    switch($_.entite)
    {
    #a partir d'ici, $_ represente l'entite, on utilise $current pour acceder au parent.
        #debut fichier
        '000' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "debut fichier"
        }
        
        '040' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "destinataire"
        }
        
        '070' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "date comptable"
        }
        
        '080' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "lot"
        }
        
        '100' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "facture"
        }
        
        '110' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "assurre"
        }
        
        '120' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "patient"
        }
        
        '150' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "nature assurance"
        }
        
        '990' {
            switch($current.niveau){
                '01' {$current | Add-Member -type noteProperty  -Name libelle -Value "fin niveau 01"}
                '02' {$current | Add-Member -type noteProperty  -Name libelle -Value "fin destinataire"}
                '03' {$current | Add-Member -type noteProperty  -Name libelle -Value "fin journée comptable"}
                '04' {$current | Add-Member -type noteProperty  -Name libelle -Value "fin lot"}
                '05' {$current | Add-Member -type noteProperty  -Name libelle -Value "fin facture"}
            }
        }
        
        '999' {
            $current | Add-Member -type noteProperty  -Name libelle -Value "fin fichier"
        }
        
    }
}



#affichage en arborescence 
$liste |foreach {
    $spaces = [Math]::min(3 * [int]($_.niveau) , 18)
    $spaces2 = 24 - $spaces
    $taille  = [Math]::min($_.data.length , 60)
    write-host ( "{0}{1}{2}{3}{4}" -f $_.numero.toString().padright(3) , (" "*$spaces) , $_.entite , (" "*$spaces2) , $_.data.substring(0,$taille) )
}

#affichage en arborescence 
$liste |foreach {
    $spaces = [Math]::min(3 * [int]($_.niveau) , 18)
    $spaces2 = 24 - $spaces
    $taille  = [Math]::min($_.data.length , 60)
    write-host ( "{0}{1}{2}{3}{4}" -f $_.numero.toString().padright(3) , (" "*$spaces) , $_.entite , (" "*$spaces2) , $_.libelle )
}





##
##idée 1 : lineariser les données imbriquées
##
$factures = @()
$infos = @{}
$liste |foreach {
    $ligne = $_
    #
    #Attention : la partie data des entite est decalée :
    #de 3 caractere pour les entitées 000 et 999
    #de 5 caracteres sinon
    
    switch($_.entite){
        "000" { 
            $infos["emetteurType"] = $ligne.data.substring(0,2)
            $infos["emetteur"] = $ligne.data.substring(2,14)
        }
        
        "040" { $infos["destinataire"] = $ligne.data.substring(0,15)}
        "070" { $infos["journee"] = $ligne.data.substring(0,6)}
        "080" { $infos["lot"] = $ligne.data.substring(6,3)}#on peut ajouter date lot
        "100" {
            $infos["facture"] = $ligne.data.substring(0,9)
            #reset infos factures
            $infos["assureMatricule"] = ''
            $infos["assureNom"] = ''
            $infos["assurePrenom"] = ''
            $infos["patientNaissance"] = ''
            $infos["patientRang"] = ''
            $infos["patientNom"] = ''
            $infos["patientPrenom"] = ''
            $infos["oc"] = ''
        }
        
        "110" { 
            $infos["assureMatricule"] = $ligne.data.substring(0,15)  
            $infos["assureNom"] = $ligne.data.substring(16,25).trim()  
            $infos["assurePrenom"] = $ligne.data.substring(67,15)
        }
        
        "120" { 
            $infos["patientNaissance"] = $ligne.data.substring(0,6)
            $infos["patientRang"] = $ligne.data.substring(6,1)
            $infos["patientNom"] = $ligne.data.substring(7,25).trim()
            $infos["patientPrenom"] = $ligne.data.substring(32,15).trim()
        }
        
        "150" { $infos["natureAssurance"] = $ligne.data.substring(0,2)}
        "160" {}
        "010" { $infos["oc"] = $ligne.data.substring(0,8)}
        "212" {}
        "212" {}
        "990" {
            if ($ligne.niveau -eq '05'){
                $infos["montant"] = $ligne.data.substring(25,11)

                $factures += New-Object -TypeName PSobject -Property @{
                    fichier = $file;
                    emetteurType = $infos["emetteurType"];
                    emetteur = $infos["emetteur"];
                    destinataire = [int]$infos["destinataire"];
                    journee  = $infos["journee"];
                    lot  = $infos["lot"];
                    facture = $infos["facture"];
                    assureMatricule = $infos["assureMatricule"];
                    assureNom = $infos["assureNom"];
                    assurePrenom = $infos["assurePrenom"];
                    patientNaissance = $infos["patientNaissance"];
                    patientRang = $infos["patientRang"];
                    patientNom = $infos["patientNom"];
                    patientPrenom = $infos["patientPrenom"];
                    natureAssurance = $infos["natureAssurance"];
                    oc = $infos["oc"];
                    montant = [int]$infos["montant"]
                }

            }
        }
    }
    
}



























function parseListe($liste,$position,$infos){
    $niveau = $liste[$postion].niveau
    
    while ($liste[$posistion].niveau -eq $niveau){
        
        switch($liste[$position].entite){
            '000'{write-host "debut"}
        }
        
        $position++
    }
    
    parseliste($liste,$position,$infos){
    
    }
    ##
}



##
##idée 2 : plusieures fonction
##

function parseFichier576(){
}

function parseLot576(){
}

function parseFacture576(){#niveau 5, infos en niveau 99
}