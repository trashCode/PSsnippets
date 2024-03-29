$dir = "D:\incoming"
$dirRegExp = $dir -replace '\','\\'
$dir2 = "D:\incoming2"

$files1 = gci $dir -recurse -force |where {$_.gettype().name -eq "FileInfo"}
$s1 = get-date
ignore = @"
foreach ($f in $files1){
    $f2 = ($f.fullname -replace $dirRegExp, "$dir2")
    if (test-path $f2){
        write-host ($f.fullname) -foreground green
    }else{
        write-host ($f.fullname) -foreground red
    }
    
}
"@
$e1 = get-date

#version 2
foreach ($f in $files1){
    $f2 = ($f.fullname -replace $dirRegExp, "$dir2")
    if (test-path $f2){
        $rf2 = get-item($f2) -force
        if ($f.LastWriteTime -eq $rf2.LastWriteTime){
            write-host ($f.fullname) -foreground green
        }else{
            write-host ($f.fullname) -foreground darkmagenta
        }
    }else{
        write-host ($f.fullname) -foreground red
    } 
}