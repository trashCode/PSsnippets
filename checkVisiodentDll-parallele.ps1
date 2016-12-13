<#
Verificateur de DLL Visiodent.
#>

$global:PMFs = @(
"S116901D0000001",
"S116901D0000002",
"S116901D0000003",
"S116901D0000004",
"S116901D0000005",
"S116901D0000006",
"S116901D0000008",
"S116901D0000010",
"S116901D0000011",
"S116901D0000012",
"S116901D0000013",
"S116901D0000014",
"S116901D0000015",
"S116901D0000017",
"S116901D0000018",
"S116901D0000019",
"S116901D0000020",
"S116901D0000021",
"S116901D0000022",
"S116901D0000023",
"S116901D0000024",
"S116901D0000026",
"S116901D0000027",
"S116901D0000030",
"S116901D0000031",
"S116901D0000032",
"S116901D0000033",
"S116901D0000037",
"S116901D0000039",
"S116901D0000040",
"S116901D0000041",
"S116901D0000043",
"S116901D0000044",
"S116901D0000045",
"S116901D0000046",
"S116901D0000047",
"S116901D0000048",
"S116901D0000049",
"S116901D0000059",
"S116901D0000060",
"S116901D0000063",
"S116901D0000064",
"S116901D0000065",
"S116901D0000066",
"S116901D0000067",
"S116901D0000068",
"S116901D0000069",
"S116901D0000077",
"S116901D0000078",
"S116901D0000085",
"S116901D0000092",
"S116901D0000098",
"S116901D0000100",
"S116901D0000101",
"S116901D0000103",
"S116901D0000104",
"S116901D0000105",
"S116901D0000106",
"S116901D0000107",
"S116901D0000108",
"S116901D0000109",
"S116901D0000110",
"S116901D0000111",
"S116901D0000112",
"S116901D0000115",
"S116901D0000119",
"S116901D0000122",
"S116901D0000123",
"S116901D0000124",
"S116901D0000125",
"S116901D0000126",
"S116901D0000128",
"S116901D0000129",
"S116901D0000131",
"S116901D0000133",
"S116901D0000134",
"S116901D0000135",
"S116901D0000136",
"S116901D0000137",
"S116901D0000138",
"S116901D0000139",
"S116901D0000140",
"S116901D0000143",
"S116901D0000145",
"S116901D0000146",
"S116901D0000147",
"S116901D0000148",
"S116901D0000150",
"S116901D0000151",
"S116901D0000152"
)


get-job|remove-job

$listings = @()
$jobs = @()

$job = {
    Param($pmf)
    $liste = @()
    
    if (test-connection $pmf -quiet){
    
        $liste = gci -Path ("\\" + $pmf + "\c$\WVISIO32\") -filter "*.dll"
        $liste += gci -Path ("\\" + $pmf + "\c$\WVISIO32\") -filter "*.exe"
        return new-object -Typename PSObject -Property @{computerName = $pmf; online=$true ;files=$liste}
    }else{
        return new-object -Typename PSObject -Property @{computerName = $pmf; online=$false ;files=$liste}
    }
    
}#end job

foreach($pmf in $PMFS){
    $jobs += start-job -scriptBlock $job -argumentList $pmf 
}

get-job | wait-job
get-job |foreach {$listings += (receive-job $_)}



         


$PMFs |foreach {
    if (test-connection $_ -quiet){
        $computerName = $_
        write-host $computerName + " online"
        $liste = @()
        $liste = gci -Path ("\\" + $computerName + "\c$\WVISIO32\") -filter "*.dll"
        $liste += gci -Path ("\\" + $computerName + "\c$\WVISIO32\") -filter "*.exe"
        $dateListing = get-date
        
        $listings += new-object -TypeName PSObject -Property @{computerName = $computerName ; files=$liste ; dateListing = $dateListing}
    }else{
        write-host $computerName + " offline"
    }
}

$listings |select computername,dateListing, @{name="nbFiles" ;Expression ={$_.files.count} }