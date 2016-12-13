$liste = "S116901D0000114",
        "S116901D0000106",
        "S116901D0000112",
        "S116901D0000115",
        "S116901D0000113",
        "S116901D0000085",
        "S116901D0000065",
        "S116901D0000107",
        "S116901D0000128",
        "S116901D0000087",
        "S116901D0000093",
        "S116901D0000058",
        "S116901D0000062",
        "S116901D0000052",
        "S116901D0000094",
        "S116901D0000069",
        "S116901D0000051",
        "S116901D0000016",
        "S116901D0000067",
        "S116901D0000088",
        "S116901D0000072",
        "S116901D0000070",
        "S116901D0000054",
        "S116901D0000076",
        "S116901D0000095",
        "S116901D0000077",
        "S116901D0000066",
        "S116901D0000053",
        "S116901D0000098",
        "S116901D0000068",
        "S116901D0000105",
        "S116901D0000080",
        "S116901D0000060",
        "S116901D0000063",
        "S116901D0000120",
        "S116901D0000064"

$liste = "S116901D0000064","P116901D0000003"
foreach ($computerName in $liste){
    if (test-connection -computerName $computerName -Quiet -count 1 ){
            $path = "\\" + $computerName + "\C$\APPLINAT\telediffusion\log\Telediffusion_locale_2015.txt"
            $lastLogin = get-content -Path  $path |select-object -last 5
            write-host($computerName + ", " + $lastLogin)
        }else{
            Write-verbose("Ping fails on " + $computerName)
        }
}