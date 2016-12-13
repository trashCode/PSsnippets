$BigFile = "D:\Pauline.7z"
$mediumFile ="D:\L500 1.2.3.1\L500_V1.2.3.1.exe"
$s = get-date
$stream = [System.IO.File]::Open("$BigFile",[System.IO.Filemode]::Open, [System.IO.FileAccess]::Read)

$hash = [System.BitConverter]::ToString($md5.ComputeHash($stream))

$e = get-date
$stream.close()
$f = get-date

Write-host(($hash -split("-") -join("")).toLower() ) -foreground green
Write-host("hasing time : " + ($e-$s).totalSeconds)