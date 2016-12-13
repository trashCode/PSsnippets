Add-Type -AssemblyName System.Drawing
#Add-Type isn't available in PS 1.0, instead you can use: [Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#source : http://stackoverflow.com/questions/2067920/can-i-draw-create-an-image-with-a-given-text-with-powershell


$y = [System.Drawing.Brushes]::Yellow
$b = [System.Drawing.Brushes]::Black