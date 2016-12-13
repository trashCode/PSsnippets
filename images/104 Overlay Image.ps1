#[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") #facultatif ? 

$currentWallpaper = (get-itemproperty 'HKCU:\Control panel\Desktop\').wallpaper

$img = new-object System.Drawing.Bitmap($currentWallpaper);
$overlay = new-object System.Drawing.Bitmap("C:\Users\FANTON-21126\Documents\5 - scripting\wallpaperMockup\sncf-crop.png");

$content = [System.Drawing.Graphics]::FromImage($img)

$brush = new-object system.Drawing.solidBrush('white');
$color = [System.Drawing.color]::FromArgb(155,255,0,0);
$brush2 = new-object system.Drawing.solidBrush($color);


$x = $img.width/2 - $overlay.width/2
$y = $img.height/2 - $overlay.height/2
$content.drawImage($overlay,$x,$y)



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

