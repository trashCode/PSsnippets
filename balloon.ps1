#
# WARNING : Script incorrect : l'icon dans le systray ne disparais jamais si on lance ce script depuis powershell_ISE.
#



[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$test = @"
ceci est un texte
multilignes !
1
2
3
4
5
"@

$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 

$objNotifyIcon.Icon = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\SetupCache\Client\Graphics\warn.ico"
$objNotifyIcon.BalloonTipIcon = "Error" 
$objNotifyIcon.BalloonTipText = $test
$objNotifyIcon.BalloonTipTitle = "File Not Found"
 
$objNotifyIcon.Visible = $True 
$objNotifyIcon.ShowBalloonTip(4000)
echo('EOF');