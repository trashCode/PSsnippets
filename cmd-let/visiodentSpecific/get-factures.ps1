##
##get-retours 
##in : fichier RSP
##out : objets retour.
##
##structure : 
##   fichier
##      (destinataire)
##          
$nestedObjectTest = @"
$zero = New-Object -TypeName PSobject -Property @{ numero = 0; niveau = 0 ; entite = "000" ; data = "osef"} 
$one = New-Object -TypeName PSobject -Property @{ numero = 1; niveau = 1 ; entite = "001" ; data = "osef"} 

$liste = @($zero , $one)

$meta = new-object -typeName PSobject -Property @{number = 2; factures = $liste}
"@

function get-factures {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {

        Write-verbose ("traitement  : " + $file.name)

        
        $table = (gc $file.fullname).split("@")
        $ref = $table[0].substring(61,3)
        
        if ($ref -ne "572" -and $ref -ne "576" -and $ref -ne "531"){
            Write-verbose($file.name + " reference non traitable : " + $ref)
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
            
            Write-verbose("ligne={0} entite={1} niveau={2}" -f $i , $entite , $niveau)
            
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
                        Write-verbose("facture trouvée")
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
        Write-verbose ($file.name + " nb factures : "  +$factures.count)
        return $factures   
    }#end PROCESS

}#end details