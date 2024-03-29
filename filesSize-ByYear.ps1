function Out-Excel

{

  param($Path = "$env:temp\$(Get-Date -Format yyyyMMddHHmmss).csv")

  $input | Export-CSV -Path $Path -UseCulture -Encoding UTF8 -NoTypeInformation


}


$hostname = hostname
$folder = "D:\WVISIO32\imagerie"
$files = gci $folder -recurse
$grouped = $files |group-object {$_.lastWriteTime.year}
#methode 1: crée un object d'affichage, on ne peut plus rien faire ensuite
$grouped |sort-object Name |format-table Name,Count,@{Label="Size";Expression={($_.group|measure-object -property Length -sum).sum /1MB}}  


#methoe 2 : ajoute aux element de grouped la propriété Size. => on peut ensuite filtrer.
$grouped |foreach {
    $current = $_ 
    $current | Add-member -type noteProperty  -Name Size -Value ($current.group|measure-object -property Length -sum).sum 
}

$grouped |where {$_.size/1MB -gt 1} | select Name,Count,@{Label="Taille";Expression={$_.size/1MB}}|out-excel "\\p116901D0000003\incoming\$hostname.csv"



