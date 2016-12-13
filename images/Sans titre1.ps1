$img = new-object System.Drawing.Bitmap("C:\Users\FANTON-21126\Documents\5 - scripting\wallpaperMockup\Base.jpg");
$content = [System.Drawing.Graphics]::FromImage($img)
$content.SmoothingMode = "AntiAlias";

$img2 = new-object System.Drawing.Bitmap("C:\Users\FANTON-21126\Documents\5 - scripting\wallpaperMockup\LogoTiny.png");
$img2.setResolution($img.HorizontalResolution,$img.VerticalResolution)

$font = new-object system.Drawing.Font("Segoe UI",40);
$color = [system.Drawing.color]::FromArgb(127,55,127,200);
$color = [system.Drawing.color]::FromArgb(200,255,255,200);


$brush = new-object system.Drawing.solidBrush($color);
$t = get-date

$content.drawString($t,$font,$brush,0,0);

display($img)