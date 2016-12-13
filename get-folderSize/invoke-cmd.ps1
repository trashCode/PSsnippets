$serveurs = gc \\w11690100suf\source\serveursVisiodent.txt
$size = invoke-command -comp $serveurs -script {gci "D:\WVISIO32" -recurse |measure-object -Prop Length -sum} -credential CNAMTS\C116901-fanton

$size | select PSComputername, @{name = "volume";Expression={$_.sum/1Gb}}