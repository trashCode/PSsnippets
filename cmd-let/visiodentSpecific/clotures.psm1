<#clotures.psm1 : 
Auteur: G.Fanton
Fournit des fonctions pour visualiser et verifier les fichiers de clotures visiodent.
#>


function get-reglementsOrg {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {
        Write-debug ("traitement  : " + $file.name)
        
        if ( [regex]::isMatch($file.name , 'Rorganis[0-9]+.csv') -and $file.length -gt 0 ){
            
            $reglements = @()
            $liste = import-csv -Delimiter ';' -path $file.fullName -Header "clinique","dateReglement","numeroFacture","numeroASS","NomASS","prenomASS","nomOrganisme","montantReglement","modeReglement","RoRc","idOrganisme","numDossier","indexReg","dateCloture"
            
            $liste |foreach {
				write-verbose $_

                $reglements += New-Object -TypeName PSobject -Property @{
                            fichier = $file;
                            fname = $file.name;
                            clinique = [int]$_.clinique;
                            dateReglement = [dateTime]::parseExact($_.dateReglement , "dd/MM/yyyy",$null );
							numeroFacture = $_.numeroFacture;
							numeroASS = $_.numeroASS;
                            NomASS = $_.NomASS;
                            prenomASS = $_.prenomASS;
							nomOrganisme = $_.nomOrganisme;
							montantReglement = [Double]( $_.montantReglement.Replace(',','.') );
                            modeReglement = $_.modeReglement;
							RoRc =$_.RoRc;
							idOrganisme = [string]$_.idOrganisme;
							numDossier = $_.numdossier;
							indexReg = $_.indexReg;
							dateCloture= [dateTime]::parseExact($_.dateCloture , "dd/MM/yyyy",$null );
                        }

            }
            return $reglements;
            
        }else{
            
            Write-debug("impossible de traiter le fichier " + $file.name );
            return;
            
        }
    }
}


function get-reglementsAss {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {
        Write-debug ("traitement  : " + $file.name)
        
        if ( [regex]::isMatch($file.name , 'Rassures[0-9]+.csv') -and $file.length -gt 0 ){
            
            $reglements = @()
            $liste = import-csv -Delimiter ';' -path $file.fullName -Header "clinique","dateOperation","numeroFacture","numeroASS","NomASS","prenomASS","montantReglement","modeReglement","numDossier","unknownNumReg","dateReglement", "regul", "dateCloture"
            
            $liste |foreach {
				write-verbose $_

                $reglements += New-Object -TypeName PSobject -Property @{
                            fichier = $file;
                            fname = $file.name;
                            clinique = [int]$_.clinique;
							dateOperation = [dateTime]::parseExact($_.dateReglement , "dd/MM/yyyy",$null );
							numeroFacture = $_.numeroFacture;
							numeroASS = $_.numeroASS;
							NomASS = $_.NomASS;
							prenomASS = $_.prenomASS;
							montantReglement  = [double]( $_.montantReglement.Replace(',','.') );#si on ne fait pas le replace, la virgule est ignorée, on obtient le montant en centimes.
							modeReglement = $_.modeReglement;
							numDossier = [int]$_.numDossier;
							unknownNumReg = $_.unknownNumReg;
							dateReglement  = [dateTime]::parseExact($_.dateReglement , "dd/MM/yyyy",$null );
							regul = $_.vide;
							dateCloture  = [dateTime]::parseExact($_.dateReglement , "dd/MM/yyyy",$null );
                        }

            }
            return $reglements;
            
        }else{
            
            Write-debug("impossible de traiter le fichier " + $file.name );
            return;
            
        }
    }
}

function get-factures {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {
        Write-debug ("traitement  : " + $file.name)
        
        if ( [regex]::isMatch($file.name , 'Ffactura[0-9]+.csv') ){
            
            $operations = @()
            $liste = import-csv -Delimiter ';' -path $file.fullName -Header "clinique","dateFacture","numeroFacture","numeroASS","NomASS","prenomASS","praticient","montantSoins","montantProtheses","montantODF","partAssure","montantRO","montantRC","creditAssure","idRo","idRc","numdossier","nomPatient","dateActe","numeroFse"
            
            $liste |foreach {
                $operations += New-Object -TypeName PSobject -Property @{
                            fichier = $file;
                            fname = $file.name;
                            clinique = [int]$_.clinique;
                            dateFacture = [dateTime]::parseExact($_.dateFacture , "dd/MM/yyyy",$null );
                            numeroFacture = $_.numeroFacture;
                            numeroASS = $_.numeroASS;
                            NomASS = $_.NomASS;
                            prenomASS = $_.prenomASS;
                            praticient = $_.praticient;
                            montantSoins = [Double]( $_.montantSoins.Replace(',','.') );
                            montantProtheses = [Double]( $_.montantProtheses.Replace(',','.') );
                            montantODF = [Double]( $_.montantODF.Replace(',','.') );
                            partAssure = [Double]( $_.partAssure.Replace(',','.') );
                            montantRO = [Double]( $_.montantRO.Replace(',','.') );
                            montantRC = [Double]( $_.montantRC.Replace(',','.') );
                            creditAssure = [Double]( $_.creditAssure.Replace(',','.') );
                            idRo = $_.idRo;
                            idRc = $_.idRc;
                            nomPatient = $_.nomPatient;
                            dateActe = [dateTime]::parseExact($_.dateActe , "dd/MM/yyyy",$null );
                            numeroFse =$_.numeroFse;
                            dossier = $_.numdossier;
                        }
            }
            return $operations;
            
        }else{
            
            Write-debug("impossible de traiter le fichier " + $file.name );
            return;
            
        }
    }
}


function get-files{
[CmdletBinding()]
    param (
        [parameter(ValueFromPipeline=$true)]
        [string]$path = $pwd.path,
        [int]$historique,
        [string]$depuis,
		[string]$du
    )
    PROCESS{
        [dateTime]$since = get-date("01-01-1900");
		[dateTime]$to = get-date("01-01-2900");
                
        if ($du.length -gt 0){
			$since = get-date($du);
			$to = $since.AddDays(1);
			return gci $path |where {$_.lastWriteTime -gt $since -and $_.lastWriteTime -lt $to}
		}
		
		if($historique -ne 0){
            $since = (get-date).AddDays(0-$historique);
            write "here $historique";
        }
        
        if ($depuis.length -gt 0){
            $since = get-date($depuis)
        }
        return gci $path |where {$_.lastWriteTime -gt $since}
        
    }
}

function Out-Excel
{

  param($Path = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv")

  $input | Export-CSV -Path $Path -UseCulture -Encoding UTF8 -NoTypeInformation

  Invoke-Item -Path $Path

}

function ed{
[CmdletBinding()]
    param (
        [parameter(ValueFromPipeline=$true)]
        [String]$path,#si l'objet passé est un fileinfo, on recupere fileinfo.toString()
        [string]$editor = "C:\Program Files\Notepad++\notepad++.exe"
    )
    
    PROCESS {
        write-verbose "path= $path"
        
        if ($path.length -eq 0){&$editor;return;}#pas d'argument, on lance juste l'editeur
        
        if (test-path $path -pathType leaf){

            &$editor $path
            
        }else{
        
            do {$result = Read-host $path " n'existe pas, voulez vous le créer ? y/N"}
            while ("Y","y","Yes","yes","ye","n","no","N","No" -notcontains $result)
                
            if ("Y","y","Yes","yes","ye" -contains $result ){
                #-force crée toute l'arborescence si besoin.
                #New-Item -ItemType file -force -Path $path
				[system.IO.file]::create((resolve-path $path).path)
                &$editor $path
            }
        }
    }#end Process
}#end function



function reload-module {
[CmdletBinding()]
    param (
        [string]$name
    )
	PROCESS {
		$module = get-module |where {$_.name -eq $name}
		
		if ($module -ne $null){
			remove-module -F $module.path 
		}
	}
	
}