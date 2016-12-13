#[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") #facultatif ? 

$img = new-object System.Drawing.Bitmap(200,200) #pas de constructeur sans arguments : on les précise ici
$img2 = new-object System.Drawing.Bitmap("C:\Users\FANTON-21126\Pictures\Logo CPAM.jpg");

$content = [System.Drawing.Graphics]::FromImage($img)
$brush = new-object system.Drawing.solidBrush('red');
$brush2 = new-object system.Drawing.solidBrush('black');

$font = new-object system.Drawing.Font("Lucida console",45);

$content.drawString("♣",$font,$brush2,0,0);
$content.drawString("♥",$font,$brush,0,45);
$content.drawString("♠",$font,$brush2,0,90);
$content.drawString("♦",$font,$brush,0,135);

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

