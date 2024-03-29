function get-SerialNumber {
<#
.SYNOPSIS
    Récupere le numero de serie d'une machine, via WMI.
    Auteur : G.Fanton
    
.PARAMETER ComputerName
    La machine dont on souhaite recupere le numero de serie

.PARAMETER pingFirst
    Effectue un ping avant, et ignore les machine qui ne reponde pas dans le delai imparti
    
.PARAMETER pingTimeOut
    Delai d'attente de la réponse au ping en ms (defaut : 150ms)
#>
[CmdletBinding()]
Param(
    [Parameter(position = 0,ValueFromPipeLine = $true)]
    [string]$computerName,
    
    [Parameter(position = 1)]
    [alias('ping','p')]
    [switch]$pingFirst,
    
    [Parameter(position = 2)]
    [alias('delay')]
    [string]$pingDelay=150
)
    
    function get-SN($computerName){
        Write-verbose("retrieving SN on " + $computerName)
        $rs = (get-wmiObject Win32_BaseBoard -computerName $computerName).SerialNumber
        return $rs      
    }
    
    if($pingFirst){
        
        if (test-connection -computerName $computerName -Quiet -count 1 ){
            get-SN($computerName)
        }else{
            Write-verbose("Ping fails on " + $computerName)
        }
        
    }else{
        get-SN($computerName)
    }
    
    
}
