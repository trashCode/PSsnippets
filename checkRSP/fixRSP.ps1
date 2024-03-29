#
#   script de deplacement des fichiers RSP mal placés lors de la télétransmission visiodent.
#   G.Fanton
#   version 1.0 06/05/2015

$hostName = $env:computername
$sender = "gregory.fanton@cpam-rhone.cnamts.fr"
$destinataires = "gregory.fanton@cpam-rhone.cnamts.fr","elodie.bacle@cpam-rhone.cnamts.fr","pascale.balancin@cpam-rhone.cnamts.fr"
$ErrorActionPreference = "stop"
$source = "D:\WVISIO32\data\basecommune\retours\RSP"
$dest = gci $source | sort | ?{$_.PSisContainer} |select -first 1 #on recupere le premier dossier (numero FINESS de la clinique)

$files = gci ($source + "\*.rsp")


if ($files.length -gt 0){

    try{

        $files |foreach {$_.copyTo($dest.fullname + "\" + $_.name)}
        $body = "Voici la liste des fichiers RSP présents sur le serveur $hostName"
        $body += "`nCes fichiers ont étés deplacés dans le dossier $dest (FINESS de la clinique) `n"
        $files|foreach {$body += "`n" + $_.name}
        send-mailMessage -To $destinataires -from $sender -subject ("{0} fichiers sur {1}" -f $files.length,$hostName) -body $body -smtpserver "smtp.cpam-rhone.cnamts.fr" -encoding ([System.Text.Encoding]::UTF8)
        
    }catch{

        send-mailMessage -To $destinataires -from $sender -subject "[fixRSP] : plantage sur $hostName" -body $_.exception.message -smtpserver "smtp.cpam-rhone.cnamts.fr" -encoding ([System.Text.Encoding]::UTF8)

    }

}