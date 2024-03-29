#source : http://www.powertheshell.com/balloontip/
function Show-BalloonTip  
{
 
  [CmdletBinding(SupportsShouldProcess = $true)]
  param
  (
    [Parameter(Mandatory=$true)]
    $Text,
   
    [Parameter(Mandatory=$true)]
    $Title,
   
    [ValidateSet('None', 'Info', 'Warning', 'Error')]
    $Icon = 'Info',

    $Timeout = 10000
  )
 
  Add-Type -AssemblyName System.Windows.Forms

  if ($script:balloon -eq $null)
  {
    $script:balloon = New-Object System.Windows.Forms.NotifyIcon
  }

  $path                    = Get-Process -id $pid | Select-Object -ExpandProperty Path
  $balloon.Icon            = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
  $balloon.BalloonTipIcon  = $Icon
  $balloon.BalloonTipText  = $Text
  $balloon.BalloonTipTitle = $Title
  $balloon.Visible         = $true

  $balloon.ShowBalloonTip($Timeout)
} 

Show-BalloonTip  -text 'text !!' -Title 'Titre:'
Show-BalloonTip  -text 'la suite !!' -Title 'Titre:'

#C'est ici que l'ont supprime l'icone de notif ! !
$script:balloon.Dispose()
Remove–Variable –Scope script –Name balloon