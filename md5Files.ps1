#on as besoin d'instancier le provider. // pas de methode static il semble.
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
#on filtre les fichier, on les passent à la moulinette, on balance nom et hash en sortie //pas encore sur que powershell comprenne la sortie.
gci|where {$_.gettype().name -eq "FileInfo"}| foreach-object {Write-host $_.name , ([System.BitConverter]::ToString(($md5.ComputeHash([System.IO.File]::ReadAllBytes($_.fullname)))))}