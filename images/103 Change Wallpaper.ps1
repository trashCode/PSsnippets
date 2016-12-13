#[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") #facultatif ? 

$currentWallpaper = (get-itemproperty 'HKCU:\Control panel\Desktop\').wallpaper

$img = new-object System.Drawing.Bitmap($currentWallpaper);

$content = [System.Drawing.Graphics]::FromImage($img)

$brush = new-object system.Drawing.solidBrush('white');
$color = [System.Drawing.color]::FromArgb(155,255,0,0);
$brush2 = new-object system.Drawing.solidBrush($color);


$lucida = new-object system.Drawing.Font("lucida console",42);
$date = get-date -Format D;


$content.drawString($date,$lucida,$brush2,0,650);



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

