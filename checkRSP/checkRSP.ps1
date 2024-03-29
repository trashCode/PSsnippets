$serveurs = get-content \\w11690100suf\source\serveursVisiodent.txt
#$serveurs =$serveurs2[0], $serveurs2[2]

for ($i=0;$i -lt $serveurs.Length;$i++){
   
    $files = gci ("\\{0}\WVISIO32\Data\BaseCommune\Retours\RSP\*.rsp" -f $serveurs[$i])
    
    if ($files.length -gt 0){
    
        Write-host $serveurs[$i] $files.length -foreground red -background black
        $dest = gci \\$serveurs[$i]\WVISIO32\Data\BaseCommune\Retours\RSP | ?{$_.PSisContainer} |select -first 1
        $destFiles = gci $dest.fullname



        #trouver les fichiers presents dans le bon dossier (quelque soit l'extension)
        $d = diff $files $destFiles -property basename -includeequal -excludedifferent
        $d

        #les fichiers seulement dans $test
        $d2 = diff $files $destFiles -property basename |where-object {$_.SideIndicator -eq "<="}
        $d2
    
    }else{
        Write-host $serveurs[$i] CLEAN -background black -foreground green
    }
}