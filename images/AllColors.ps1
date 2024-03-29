function display ($img){
    [System.Windows.Forms.Application]::EnableVisualStyles();
    $form = new-object Windows.Forms.Form
    $form.Text = "Image Viewer"
    $form.Width = $img.Size.Width+20;
    $form.Height = $img.Size.Height+40;
    $pictureBox = new-object Windows.Forms.PictureBox
    $pictureBox.Width = $img.Size.Width;
    $pictureBox.Height = $img.Size.Height;
     
    $pictureBox.Image = $img;
    $form.controls.add($pictureBox)
    $form.Add_Shown( { $form.Activate() } )
    $form.ShowDialog()
    #$form.Show(); 
    stat-sleep 5
    $form.dispose()
}


#Objectifs : faire un nuancier de toutes les couleures disponibles nommées
#on dessine une zone de 1200*900 :
# 6 colones de 200
# 50 colonnes de 36
# pour 150 zones (141 colors sont définies)

Add-Type -AssemblyName System.Drawing
$Brushes = [System.Drawing.Brushes]
#[Version 0] Attention : $Allcolors ne contient pas les objets, mais seulement les Nom !
#$AllColors = ($Brushes.getmembers() |where-object {$_.memberType -eq 'Property'} |select-object -property Name)

#[Version 1]mieux !
$AllColors = $Brushes.getmembers() |where-object {$_.memberType -eq 'Property'}
$AllBrushes = @()
for($i=0;$i -lt $AllColors.count;$i++){
    $AllBrushes += [system.drawing.Brushes]::($Allcolors[$i].Name)
}
#[Version 1] vu que nous avons un tableau d'objet, on peut les trier (par autre chose que le nom)
#$AllBrushes = $allBrushes |sort-object {$_.color.R}  #classé selon les composante rouge
$AllBrushes = $allBrushes |sort-object {($_.color.getHue()+180)%360} #classé selon la composante chromatique avec decalage 180° 

$font = new-object system.Drawing.Font("Segoe UI",12);


$img = new-object System.Drawing.Bitmap(1200,900)
$content = [System.Drawing.Graphics]::FromImage($img)

$r = new-object System.drawing.rectangle(0,0,200,36)#le rectangle de 200 par 36, on changera simplement ses coord pour dessiner.

for ($i=0;$i -lt $allBrushes.count;$i++){
    $r.y = ($i*36)%900
    $r.x = 200*[MAth]::floor(($i*36)/900)

    $content.FillRectangle($AllBrushes[$i],$r)
    $color = $AllBrushes[$i].color

    #on ecrit le nom de la couleur dans l'inverse de brighness
    if($color.getBrightness() -lt 0.5){
        $content.drawString($color.Name + " (" + [Math]::floor($color.getBrightness()*100) + ")",$font,[system.drawing.brushes]::White,$r.x,$r.y);
    }else{
        $content.drawString($color.Name+ " (" + [Math]::floor($color.getBrightness()*100) + ")",$font,[system.drawing.brushes]::Black,$r.x,$r.y);
    }

    
}


display($img);


