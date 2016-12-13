<#noemie.psm1 : 
Auteur: G.Fanton
Fournit des fonctions pour visualiser et verifier les fichiers RSP / B2.
#>

#get-paiementRSP : parse un fichier rsp reference 572/576/531 pour extraire les paiements, par facture.
function get-paiementRSP {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {

        Write-debug ("traitement  : " + $file.name)

        
        $table = (gc $file.fullname).split("@")
        $ref = $table[0].substring(61,3)
        
        if ($ref -ne "572" -and $ref -ne "576" -and $ref -ne "531"){
            Write-debug($file.name + " reference non traitable : " + $ref)
            return
        }
        
        $factures = @()
        $infos = @{} #buffer des facures 
        
        #parcours des lignes
        for ($i = 0 ; $i -lt $table.count ; $i++){
            $entite = $table[$i].substring(0,3)
            
            if ($entite -ne "000" -and $entite -ne "999"){
                $niveau = $table[$i].substring(3,2)
            }else{
                $niveau = "01"
            }#end if
            
            write-debug("ligne={0} entite={1} niveau={2}" -f $i , $entite , $niveau)
            
            switch($entite){
                "000" { 
                    $infos["emetteurType"] = $table[$i].substring(3,2)
                    $infos["emetteur"] = $table[$i].substring(5,14)
                }
                
                "040" { $infos["destinataire"] = $table[$i].substring(5,15)}
                "070" { $infos["journee"] = $table[$i].substring(5,6)}
                "080" { $infos["lot"] = $table[$i].substring(11,3)}#on peut ajouter date lot
                "100" {
                    $infos["fse"] = $table[$i].substring(5,9)
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
                    $infos["assureMatricule"] = $table[$i].substring(5,15)  
                    $infos["assureNom"] = $table[$i].substring(21,25).trim()  
                    $infos["assurePrenom"] = $table[$i].substring(72,15)
                }
                
                "120" { 
                    $infos["patientNaissance"] = $table[$i].substring(5,6)
                    $infos["patientRang"] = $table[$i].substring(11,1)
                    $infos["patientNom"] = $table[$i].substring(12,25).trim()
                    $infos["patientPrenom"] = $table[$i].substring(37,15).trim()
                }
                
                "150" { $infos["natureAssurance"] = $table[$i].substring(5,2)}
                "160" {}
                "010" { $infos["oc"] = $table[$i].substring(5,8)}
                "212" {}
                "212" {}
                "990" {       
                    if ($niveau -eq '05'){
                        $infos["montant"] = $table[$i].substring(30,11)
                        write-debug("facture trouvée")
                        $factures += New-Object -TypeName PSobject -Property @{
                            fichier = $file;
                            fname = $file.name;
                            emetteurType = $infos["emetteurType"];
                            emetteur = $infos["emetteur"];
                            destinataire = [int]$infos["destinataire"];
                            journee  = $infos["journee"];
                            lot  = $infos["lot"];
                            fse = $infos["fse"];
                            assureMatricule = $infos["assureMatricule"];
                            assureNom = $infos["assureNom"];
                            assurePrenom = $infos["assurePrenom"];
                            patientNaissance = $infos["patientNaissance"];
                            patientRang = $infos["patientRang"];
                            patientNom = $infos["patientNom"];
                            patientPrenom = $infos["patientPrenom"];
                            natureAssurance = $infos["natureAssurance"];
                            oc = $infos["oc"];
                            montant = [double]$infos["montant"]/100
                        }

                    }#end if
                }#end990
            }#end switch
            
        }#end for
        write-debug ($file.name + " nb factures : "  +$factures.count)
        return $factures   
    }#end PROCESS

}#end function


#get-rejetRSP : parse un fichier rsp reference 900 pour extraire les paiements, par facture.
function get-rejetRSP {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {

        Write-debug ("traitement  : " + $file.name)

        
        $table = (gc $file.fullname).split("@")
        $ref = $table[0].substring(61,3)
        
        if ($ref -ne "900" -and $ref -ne "908"){
            Write-debug($file.name + " reference non traitable : " + $ref)
            return
        }
        
        $factures = @()
        $infos = @{} #buffer des facures 
        
        #parcours des lignes
        for ($i = 0 ; $i -lt $table.count ; $i++){
            $entite = $table[$i].substring(0,3)
            
            if ($entite -ne "000" -and $entite -ne "999"){
                $niveau = $table[$i].substring(3,2)
            }else{
                $niveau = "01"
            }#end if
            
            write-debug("ligne={0} entite={1} niveau={2}" -f $i , $entite , $niveau)
            
            switch($entite){
                "000" { 
                    $infos["emetteurType"] = $table[$i].substring(3,2)
                    $infos["emetteur"] = $table[$i].substring(5,14)
                }
                
                "040" { $infos["destinataire"] = $table[$i].substring(5,15)}
                "070" { $infos["journee"] = $table[$i].substring(5,6)}
                "080" { $infos["lot"] = $table[$i].substring(11,3)}#on peut ajouter date lot
                "100" {
                    $infos["fse"] = $table[$i].substring(5,9)
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
                    $infos["assureMatricule"] = $table[$i].substring(5,15)  
                    $infos["assureNom"] = $table[$i].substring(21,25).trim()  
                    $infos["assurePrenom"] = $table[$i].substring(72,15)
                }
                
                "120" { 
                    $infos["patientNaissance"] = $table[$i].substring(5,6)
                    $infos["patientRang"] = $table[$i].substring(11,1)
                    $infos["patientNom"] = $table[$i].substring(12,25).trim()
                    $infos["patientPrenom"] = $table[$i].substring(37,15).trim()
                }
                
                "150" { $infos["natureAssurance"] = $table[$i].substring(5,2)}
                "160" {}
                "010" { $infos["oc"] = $table[$i].substring(5,8)}
                "212" {}
                "212" {}
                "990" {       
                    if ($niveau -eq '05'){
                        $infos["montant"] = $table[$i].substring(30,11)
                        write-debug("facture trouvée")
                        $factures += New-Object -TypeName PSobject -Property @{
                            fichier = $file;
                            fname = $file.name;
                            emetteurType = $infos["emetteurType"];
                            emetteur = $infos["emetteur"];
                            destinataire = [int]$infos["destinataire"];
                            journee  = $infos["journee"];
                            lot  = $infos["lot"];
                            fse = $infos["fse"];
                            assureMatricule = $infos["assureMatricule"];
                            assureNom = $infos["assureNom"];
                            assurePrenom = $infos["assurePrenom"];
                            patientNaissance = $infos["patientNaissance"];
                            patientRang = $infos["patientRang"];
                            patientNom = $infos["patientNom"];
                            patientPrenom = $infos["patientPrenom"];
                            natureAssurance = $infos["natureAssurance"];
                            oc = $infos["oc"];
                            montant = [double]$infos["montant"]/100
                        }

                    }#end if
                }#end990
            }#end switch
            
        }#end for
        write-debug ($file.name + " nb factures : "  +$factures.count)
        return $factures   
    }#end PROCESS

}#end function




#eclate-rsp : parse un rsp pour retourner une liste d'entitée (infos sont ref, niveau, entité, data)
function eclate-rsp {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [system.io.fileinfo]$file,
        
        [parameter(Mandatory=$false)]
        [alias("PF")]
        [switch]$pingfirst
        
    )
    PROCESS {
        <#
        write-output("-"*$file.name.length)
        Write-output $file.name
        write-output("-"*$file.name.length)
        #>
        $table = (gc $file.fullname).split("@")
        
        $liste = @()
        $ref = $table[0].substring(61,3)
        for ($i = 0 ; $i -lt $table.count ; $i++){
            $entite = $table[$i].substring(0,3)
            
            if ($entite -ne "000" -and $entite -ne "999"){
                $niveau = $table[$i].substring(3,2)
            }else{
              
                $niveau = "01"
            }#end if
            
            #$data = $table[$i].substring(5 , $table[$i].length - 5)
			$data = $table[$i]
            $liste += New-Object -TypeName PSobject -Property @{ file = $file; ref = $ref; numero = $i; niveau = $niveau ; entite = $entite ; data = $data} #ok !
        }#end for
        
        return $liste
    
    }
}

#show-rsp : affiche un rsp en mode texte.
function show-rsp {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [system.io.fileinfo]$file,
        
        [parameter(Mandatory=$false)]
        [alias("PF")]
        [switch]$pingfirst

    )
    PROCESS {
			$entite_details = @{
			"000" =@{id = "000"; code="NOP-ENT"; libelle="entete";}
			"010" =@{id = "010"; code="NOP-OCO"; libelle="organisme complementaire";}
			"020" =@{id = "020"; code="NOP-MND"; libelle="mandataire";}
			"040" =@{id = "040"; code="NOP-DRG"; libelle="destinataire";}
			"070" =@{id = "070"; code="NOP-DAT"; libelle="date journée comptable";}
			"080" =@{id = "080"; code="NOP-LOT"; libelle="lot";}
			"100" =@{id = "100"; code="NOP-FAC"; libelle="facture";}
			"105" =@{id = "105"; code="NOP-TIT"; libelle="titre H.P.";}
			"110" =@{id = "110"; code="NOP-ASS"; libelle="assuré";}
			"120" =@{id = "120"; code="NOP-MAL"; libelle="malade";}
			"150" =@{id = "150"; code="NOP-ASU"; libelle="nature d'assurance";}
			"160" =@{id = "160"; code="NOP-ARC"; libelle="critere d'archivage";}
			"210" =@{id = "210"; code="NOP-PAP"; libelle="acte professionnel";}
			"212" =@{id = "212"; code="NOP-PEX"; libelle="acte professionnel avec executant";}
			"216" =@{id = "216"; code="NOP-PEP"; libelle="acte professionnel avec executant et prescripteur";}
			"220" =@{id = "220"; code="NOP-PHS"; libelle="frais hospitaliers";}
			"250" =@{id = "250"; code="NOP-MFI"; libelle="mouvement financier";}
			"290" =@{id = "290"; code="NOP-LRS"; libelle="rejet ou signalement";}
			"990" =@{id = "990"; code="NOP-CTL"; libelle="controle";}
			"999" =@{id = "999"; code="NOP-FIN"; libelle="fin de fichier";}
		}#fin $entite
	
        write-output("-"*$file.name.length)
        Write-output $file.name
        write-output("-"*$file.name.length)
        $table = (gc $file.fullname).split("@")
        
        $liste = @()
        for ($i = 0 ; $i -lt $table.count ; $i++){
            $entite = $table[$i].substring(0,3)
            
            if ($entite -ne "000" -and $entite -ne "999"){
                $niveau = $table[$i].substring(3,2)
            }else{
                $niveau = "01"
            }#end if
            
            $data = $table[$i].substring(5 , $table[$i].length - 5)
            $liste += New-Object -TypeName PSobject -Property @{ numero = $i; niveau = $niveau ; entite = $entite ;libelle = $entite_details[$entite].libelle; data = $data} #ok !
        }#end for
        
		#recherche des plus longues chaines pour affichage clair
		$max = 0;
		$liste |foreach{$max = [Math]::max($max,$_.libelle.length)}
		$maxWidth = $host.UI.rawUI.maxwindowsize.width
		
		<#
			$maxWidth = $host.UI.rawUI.maxwindowsize.width
			colones : 
				numero ligne (4)
				num entite (24)
				libelle ($max+1)
				reste 160
			
		#>
		
        $liste |foreach {
            $spaces = [Math]::min(3 * [int]($_.niveau) , 18)
            $spaces2 = 24 - $spaces
            $taille  = [Math]::min($_.data.length , 60)
            #write-output ( "{0}{1}{2}{3}{4}" -f $_.numero.toString().padright(3) , (" "*$spaces) , $_.entite , (" "*$spaces2) , $_.data.substring(0,$taille) )
			write-host ( "{0}{1}{2}{3}{4}" -f $_.numero.toString().padright(4) , (" "*$spaces) , $_.entite , (" "*$spaces2) , $_.libelle.padright($max+1), $_.data.substring(0,$taille) ) -nonewline
			#write-host -backGroundColor Black $_.data.substring(0 , [Math]::min($maxWidth-$max-28,$_.data.Length-1))
			write-host -backGroundColor Black  -foreground Gray $_.data.padRight($maxWidth).substring(0 , $maxWidth-$max-33)
        }#end foreach
    
    }
}#end function

#eclate-b2 : parse un fichier b2, retourne une liste des lignes du fichiers b2 
function eclate-b2 {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [system.io.fileinfo]$file
        
    )
    PROCESS {
        $Buffer = New-Object Byte[] 128
        $line = @()
        $decoder = new-Object System.Text.ASCIIEncoding
        #$stream = [System.IO.File]::Create($file) ## /!\ DANGER : creer un stream vide : flush le fichier s'il existe deja !!

        if (test-Path $file){
            $stream = new-object System.IO.FileStream($file,[System.IO.fileMode]::open)

            Do {
                #...attemt to read one kilobyte of data from the web response stream.
                $nbBytesRead = $stream.Read($Buffer, 0 , $Buffer.Length)
                $line += $decoder.getString($buffer)
                #write ("position : {0}    octets lu : {1}" -f $stream.position,$nbBytesRead)
            } While ($nbBytesRead -gt 0)
            
            $stream.close()
        }else{
            write "unable to read file";
        }#end if
        return $line
    }#end Process
}#end function





