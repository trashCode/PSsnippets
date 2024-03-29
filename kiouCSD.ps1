$about = @"
    Script de démarage powershell
    0) se met a jour automatiquement.
    1) recupere infos du poste : IP, computername, numero de serie
    2) log session dans base de données (ou journal local sinon)
    3) en fonction du poste : 
        Si clinique : 
            verifie le lecteur V
            verifie le registre pour l'export de la cloture
            corrige des colones des tableaux Visiodent (en base de données)
            met a jour visiolab
            met a jour croc
            active la CCAM
            retabli les macro word
        Commun : 
            verifie le dossier application reseau CSD.
            Affiche un rapport des actions corrigé.
            imprimantes ? 
"@

#objet globaux.
$version = 7

#infos reseau
$ips=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 0}|where {$_.IPAddress[0] -like "55*"}
$ip=$ips.IPAddress[0]
$mac = $ips.MACAddress

#infos inventaire
$infos = get-WmiObject Win32_ComputerSystemProduct
$serial = $infos.IdentifyingNumber
$model = $infos.Name

$hostName = $env:computername
$userName = $env:username

function log2db(){
    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = "server='w11690100sbf';database='parcinfo';trusted_connection=true;"
    $Connection.Open()

    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection

    $Command.CommandText = "insert into kiouCSD(hostname,ip,mac,model,serial,username) VALUES (@hostname,@ip,@mac,@model,@serial,@username)"
    $ignore = $Command.Parameters.Add("@hostname", $hostname);
    $ignore = $Command.Parameters.Add("@ip", $ip);
    $ignore = $Command.Parameters.Add("@mac", $mac);
    $ignore = $Command.Parameters.Add("@model", $model);
    $ignore = $Command.Parameters.Add("@serial", $serial);
    $ignore = $Command.Parameters.Add("@username", $username);

    $rs = $Command.ExecuteNonQuery()
    $rs
    $Connection.Close()
}

log2db


