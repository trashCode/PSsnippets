$Greg = "gregory.fanton@cpam-rhone.cnamts.fr"
$dest = "gregory.fanton@cpam-rhone.cnamts.fr","elodie.bacle@cpam-rhone.cnamts.fr"
$body = @"
Bonjour
ceci est un text
envoyé le {0}

Cordialement,
"@ -f (get-date)
send-mailmessage -To $dest -From $Greg -smtpServer "smtp.cpam-rhone.cnamts.fr" -subject "mail de test" -body $body -encoding ([System.Text.Encoding]::UTF8)