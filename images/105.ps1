#[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") #facultatif ? 


#$img = new-object System.Drawing.Bitmap(200,200);
#$img = new-object System.Drawing.Bitmap((get-itemproperty 'HKCU:\Control panel\Desktop\').wallpaper);
$img = new-object System.Drawing.Bitmap("C:\Users\FANTON-21126\Documents\5 - scripting\wallpaperMockup\Base.jpg");

#$img2 = new-object System.Drawing.Bitmap(400,230);
$img2 = new-object System.Drawing.Bitmap("C:\Users\FANTON-21126\Documents\5 - scripting\wallpaperMockup\LogoTiny.png");
$img2.setResolution($img.HorizontalResolution,$img.VerticalResolution)

$content = [System.Drawing.Graphics]::FromImage($img)
$content2 = [System.Drawing.Graphics]::FromImage($img2)

#$content.clear('black');
#$content2.clear('red');
$x = $img.width/2 - $img2.width/2
$y = $img.height/2 - $img2.height/2

$f = new-object system.Drawing.Font("Lucida console",10);
$brush = new-object system.Drawing.solidBrush('white');
$t  = "{0},{1}" -f $x,$y
$content.drawString($t,$f,$brush,0,0);


### Superposition de l'image 2 sur la 1 
$content.drawImage($img2,$x-300,$y);

### Superposition de l'image 2 sur la 1 
$content.smoothingMode = "highSpeed";
$rect = new-object System.drawing.rectangle(($x+300),($y),($img2.width),($img2.height))
$attrib = new-object System.Drawing.Imaging.ImageAttributes

$matrice = new-object System.Drawing.Imaging.ColorMatrix;
<#
$matrice.Matrix00 = 0.99
$matrice.Matrix11 = 0.99
$matrice.Matrix22 = 0.99
$matrice.Matrix33 = 1;
$matrice.Matrix44 = 1;
$matrice.Matrix40 = $matrice.Matrix41 = $matrice.Matrix42 = 0.2;
#>

#matrice d'inversion.
$matrice.Matrix00 = -1
$matrice.Matrix11 = -1
$matrice.Matrix22 = -1
$matrice.Matrix33 = $matrice.Matrix44 = 1
$matrice.Matrix40 =$matrice.Matrix41 =$matrice.Matrix42 = 1

$attrib.setColorMatrix($matrice)

$unit = [System.drawing.GraphicsUnit]::Pixel;

$content.drawImage($img2,$rect,0,0,($img2.width),($img2.height),$unit,$attrib);


$color = [System.Drawing.color]::FromArgb(155,255,0,0);
$brush2 = new-object system.Drawing.solidBrush($color);


$pen = new-object system.Drawing.Pen('black',2);

#### lignes pour le centrage.
$content.smoothingMode = "HighQuality";
#$content.drawLine($pen,0,0,$img.width,$img.height)
$content.smoothingMode = "AntiAlias";
#$content.drawLine($pen,0,$img.height,$img.width,0)




display($img)



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
}


