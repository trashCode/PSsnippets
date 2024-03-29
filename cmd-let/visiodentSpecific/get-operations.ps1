function get-operations {
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