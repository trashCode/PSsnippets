$csv = "C:\users\Fanton-21126\desktop\listePMF.csv"
$header = (gc $csv -encoding UTF8)[0].split(";")
$header = $header[0..($header.count-2)]

for ($i=0;$i -lt $header.count ; $i++){
    $header[$i] = $header[$i].replace('"',"")
}

$pmfs = import-csv -path $csv -delimiter ';' -header $header
#on supprime la premiere ligne (qui contient le header)
$pmfs = $pmfs[1..($pmfs.count-1)]

$pmfs = $pmfs |add-Member ScriptMethod get {return ($this |where {$_.nom -eq "S116901D0000005"} ) } -passthru