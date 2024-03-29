<#Check Clotures : 
Auteur: G.Fanton
Recherche de factures erronées dans les clotures visiodent.
#>


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

##MAIN 

#On parse les fichiers de clotures
$files = gci -filter "Ffactura*.csv" -Path D:\clotures\ -recurse |where {$_.lastWriteTime -gt (get-date).addHours(-24)}
$ops = $files |get-operations

#On cherche les brebis galeuses : 
$manque = $ops | where {($_.montantRo  -ne 0 -and $_.idRo -eq "") -or ($_.montantRc  -ne 0 -and $_.idRc -eq "")}
##Attention : on doit faire tous les tests dans la meme clause where. Si plusieurs closes, on peut avoir des sous resultat de type operation au lieu de tableau, et l'opérateur + ne fonctionne pas.serv


#si on en trouve : 
if ($manque -ne $null){
    $body = $manque |Format-table `
    -property `
        clinique,`
        numeroFacture,`
        @{Label="date Facture"; Expression={$_.dateFacture.ToString("dd/MM/yy")} },`
        @{Label="montant Ro"; Expression={"{0:c}" -f $_.montantRo} },`
        @{Label="identRo"; Expression={$_.idRo} },`
        @{Label="montant Rc"; Expression={"{0:c}" -f $_.montantRc} },`
        @{Label="identRc"; Expression={$_.idRc} }`
        -AutoSize -groupby clinique |convertTo-html -Head $style -PreContent "C'est planté!"

    #mise en forme pour HTML report
    $style = "<style> TABLE {border: 1px solid black; border-collapse : collapse;} TH{border:1px solid black; background: #cccccc; padding:5px;} TD{border:1px solid black;padding-right: 5px ; padding-left:5px;}</style>"
    $precontent = "Visiodent s'est encore prit les pieds dans le tapis...(les debits ne seront pas egaux aux crédits)"
    $postContent = "Generé le {0}" -f (get-date)
    $body = $manque |select `
    clinique,`
    dossier,`
    numeroFacture,`
    @{Label="date Facture"; Expression={$_.dateFacture.ToString("dd/MM/yy")} },`
    @{Label="montant Ro"; Expression={"{0:c}" -f $_.montantRo} },`
    @{Label="identRo"; Expression={$_.idRo} },`
    @{Label="montant Rc"; Expression={"{0:c}" -f $_.montantRc} },`
    @{Label="identRc"; Expression={$_.idRc} }`
    |convertTo-html -Head $style -PreContent $precontent -PostContent $postContent




    #on informe les autorités comptétentes 
    $sender = "gregory.fanton@cpam-rhone.cnamts.fr"
    $dest = "gregory.fanton@cpam-rhone.cnamts.fr"

    send-mailmessage -To $dest -From $sender -smtpServer "smtp.cpam-rhone.cnamts.fr" -subject "verification cloture" -BodyAsHtml -body ($body |out-string) -encoding ([System.Text.Encoding]::UTF8)
#pas de Factures erronées.     
}else{

    $sender = "gregory.fanton@cpam-rhone.cnamts.fr"
    $dest = "gregory.fanton@cpam-rhone.cnamts.fr"
    $style = "<style> TABLE {border: 1px solid black; border-collapse : collapse;} TH{border:1px solid black; background: #cccccc; padding:5px;} TD{border:1px solid black;padding-right: 5px ; padding-left:5px;}</style>"
    $precontent = "Verification clotures : {0} fichiers de Facturation traités, et pas d'erreures" -f $files.count
    $postContent = "Generé le {0}" -f (get-date)
    $body = $files | select @{Label = "clinique"; Expression = {$_.Directory.name} },name |convertTo-html -Head $style -PreContent $precontent -PostContent $postContent
    
    send-mailmessage -To $dest -From $sender -smtpServer "smtp.cpam-rhone.cnamts.fr" -subject "verification cloture" -BodyAsHtml -body ($body |out-string) -encoding ([System.Text.Encoding]::UTF8)
    
}