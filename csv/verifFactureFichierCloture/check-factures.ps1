#
#Objectif : verifier les fichier de facturation a la cloture de visiodent pour detecter les aberations du type :
#Montant total different de la somme des montants répartits.
#TODO :
#     -identifier les colones test, notament test 3
#     -gerer les problemes d'importation csv si besoin.
#
#header du csv a ce jour : 
# "clinique","dateFacture","numeroFacture","numeroASS","NomASS","prenomASS","praticient","montant","test1","test2","montantRO","montantRC","test3","test4","idOrganisme","test5","numdossier","nomPatient","dateActe","numeroFse"
#
#La colone credit assurré peut correspondre :
#     -a des regularisation d'accompte (attention, la part a charge est réduite d'autant) voir facture 14194 dossier ROCHAS
#

$files = gci \\w11690100suf\clotures\saintfons\Ffactura20160608.csv

$script = $Myinvocation.MyCommand.Definition.split("\")
$path = $script[0]

#on se place dans le dossier du script.
<#
for($i=1 ; $i -lt $script.length -1 ; $i++){
    $path += "\"+$script[$i]<
}
$file = ".\Ffactura20150725.csv"
cd $path
#>

foreach ($file in $files)
{ 
    $liste = import-csv -Delimiter ';' -path $file.fullName -Header "clinique","dateFacture","numeroFacture","numeroASS","NomASS","prenomASS","praticient","montantSoins","montantProtheses","montantODF","partAssure","montantRO","montantRC","creditAssure","idRo","idRc","numdossier","nomPatient","dateActe","numeroFse"
    #$liste |format-table

    #$liste |foreach { write-host( $_.numeroFacture +" : "+ [string]( [int]$_.montant - [int]$_.montantRO - [int]$_.montantRC ) ) }


    $liste |foreach {
        $mnt = [int]$_.montantSoins + [int]$_.montantProtheses + [int]$_.montantODF - [int]$_.partAssure - [int]$_.montantRO - [int]$_.montantRC -[int]$_.creditAssure
        
        if ($mnt -ne 0){
            write-host($_.numeroFacture + " : " + $mnt)
            #$_ |format-table
            #write-host($_.numeroFacture + " : " + $mnt)
        }
    }
}