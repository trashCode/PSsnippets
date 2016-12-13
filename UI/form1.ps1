#[System.Windows.Forms.Application]::EnableVisualStyles();
add-type -AssemblyName System.windows.Forms
$mainDesktopSize = [System.windows.Forms.screen]::PrimaryScreen.workingArea

$form = new-object Windows.Forms.Form
$form.Text = "Simple Form 1"
$form.width = 400
$form.height = 150

#positionnement 
$x = $mainDesktopSize.width - $form.width
$y = $mainDesktopSize.height - $form.height
$form.setDesktopLocation($x,$y);
$form.startposition = [System.windows.Forms.FormStartPosition]::Manual



#$form.setDesktopLocation($y,$x)
#$form.setDesktopLocation(0,0)
$grey = [system.Drawing.colorTranslator]::Fromhtml("#1E1E1E");
$grey2 = [system.Drawing.colorTranslator]::Fromhtml("#464646");
$keyword = [system.Drawing.colorTranslator]::Fromhtml("#96DD3B");
$white = [system.Drawing.colorTranslator]::Fromhtml("#F8F8F8");
$green = [system.Drawing.colorTranslator]::Fromhtml("#9DF39F");
$darkGreen = [system.Drawing.colorTranslator]::Fromhtml("#0B2F20");
$darkGreen2 = [system.Drawing.colorTranslator]::Fromhtml("#0A2B1D");
$what = [system.Drawing.colorTranslator]::Fromhtml("#B9BDB6");




$c0 = [system.Drawing.color]::FromArgb(255,117,105,83);
$c1 = [system.Drawing.color]::FromArgb(255,255,246,231);
$c2 = [system.Drawing.color]::FromArgb(255,194,180,156);
$c3 = [system.Drawing.color]::FromArgb(255,71,94,117);
$c4 = [system.Drawing.color]::FromArgb(255,156,175,194);
$form.backColor = $darkGreen2


$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle;

#Ajout d'un label
$font = new-object system.Drawing.Font("Lucida console",16);
$Label = New-Object System.Windows.Forms.Label
$Label.forecolor = $keyword;
$Label.Text = "Sample Text"
$label.font = $font;
$Label.AutoSize = $True
$Form.Controls.Add($Label)

##interception touches clavier
$form.KeyPreview = $True
$form.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$label.forecolor = $white}})
$form.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$form.Close()}})

#Masque les boutons de titleNBar
$Form.MinimizeBox = $False
$Form.MaximizeBox = $False
#$Form.ControlBox = $False

#$form.opacity= 0.7


$form.ShowDialog()






