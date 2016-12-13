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



#[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") #facultatif ? 

$img = new-object System.Drawing.Bitmap(200,200) #pas de constructeur sans arguments : on les précise ici
$content = [System.Drawing.Graphics]::FromImage($img)
$content.clear('blue');
display($img)

$img2 = new-object System.Drawing.Bitmap("C:\Users\FANTON-21126\Pictures\Logo CPAM.jpg");


