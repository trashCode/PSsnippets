$dossierSource = "D:\SEF - ortho\imagerie"
$dossierSauvegarde = "\\P116901D0000003\incoming\img"

$png = gci $dossierSource -recurse -filter "*.png"

$png[0..10]|foreach {
    $rs = shrink-colorImage($_)
    
    if ($rs){
        $rs.lastWriteTime = $_.lastWriteTime
        $dest = ($_.fullname.replace("D:\incoming\img",$dossierSauvegarde))
        
        if ( !(test-path (split-path $dest))) {
            $osef = new-item -path (split-path $dest) -type directory
        }
        
        $_.moveTo($dest)
        write-host ("{0} ok" -f $_.fullname)
    }else{
        write-host ("{0} n'as pu etre traité" -f $_.fullname)
    }#end if 
    
}#end foreach