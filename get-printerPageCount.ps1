<######################################
Script de recuperation des compteurs d'imprimantes
Auteur : CPAM du Rhône - Gregory Fanton
Crée le 01/03/2016 

Requiert l'activation du serveur RCP sur les serveurs d'impressions en windows. (Pour les requettes WMI)
Requiert snmpget.exe pour les requetes snmp.
######################################>
$cred = get-credential -credential "C116901-fanton"
$printers = $null
$serveurs = "w11690100snf","w11690100sof","w11690100spf","w11690100sqf","w11690100srf","w11690100ssf","w11690100stf","w11690100suf"
$snmpwalker = 'C:\Users\FANTON-21126\Desktop\snmp 6.0\snmpget.exe'
$arg1 ='-c=public'
$arg2 ='-v=1'
$arg3 ='55.137.14.64'
$argMIBlexmark ='1.3.6.1.2.1.43.10.2.1.4.1.1'

$serveurs |foreach {$printers += Get-WMIObject -Class Win32_Printer -Computer $_ -credential $cred}

$printers = $printers |where {$_.name -like "ICSDR*"}|sort -property portname -uniq

$printers |foreach {
    #if ($_.drivername -eq "Lexmark X364dn" -or $_.drivername -eq "HP LaserJet M1522 MFP Series PCL 6" -or $_.drivername -eq "RICOH Aficio MP 4000 RPCS"){
        #Lexmark supporte snmp V1 et V2 / Laserjet V1 only

        $pageCount = &$snmpwalker $arg1 $arg2 $_.portname $argMIBlexmark
        if ($pageCount -match 'Data:'){
            $pageCount = $pageCount -replace '.*Data: ([0-9]+)','$1'
            $_ | Add-Member -type noteProperty  -Name pageCount -Value $pageCount
        }else{
            $_ | Add-Member -type noteProperty  -Name pageCount -Value "timeout"
        }
 
    #}
   
}
$printers |sort -property pageCount |select name,portname,drivername,pageCount
$printers |select name,systemName,driverName,@{Name='pCount';Expression={[Int]$_.pageCount}}|sort -property pCount -desc|out-excel
