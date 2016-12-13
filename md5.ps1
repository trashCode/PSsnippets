$someFilePath = "d:\suiviProd.mdb"
$someFilePath = "d:\Partdieu-01-06-2016.7z"

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider

$s = get-Date
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($someFilePath)))
$e = get-date
Write-host("UnFormated : " + $hash.ToLower()) -foreground blue
Write-host("Formated : " + ($hash -split("-") -join("")).tolower()) -foreground green
# $hash -split("-") -join("") #-split et -join ne modifient pas la variable.

$hash = $hash -split("-") -join("")  #la c'est ok

Write-host("Formated : " + $hash.ToLower()) -foreground green
Write-host("hash computing time : " + ($e-$s).TotalMilliseconds + "ms (" + ($e-$s).ticks +" ticks)")