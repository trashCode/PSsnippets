#Add-Type -AssemblyName System.Drawing
function shrink-colorImage {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file,
        
        [parameter(Mandatory=$false)]
        [alias("q")]
        [int32]$quality
    )
    PROCESS {
        Add-Type -AssemblyName System.Drawing
        #pour greyscale : Format8bppIndexed
        $quality = 75

        
        #test destination
        $dest = $file.fullname -replace ".png",".jpg"

        if (test-path ($dest)){return $false}
        
        $bmp = new-object System.Drawing.Bitmap($file.fullname)
        
        if ( $bmp.pixelFormat -eq "Format24bppRgb" ){
            
            $myEncoder = [System.Drawing.Imaging.Encoder]::Quality
            $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1) 
            $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($myEncoder, $quality)
            
            # get codec
            $myImageCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()|where {$_.MimeType -eq 'image/jpeg'}
    
            #save to file
            $bmp.Save($dest,$myImageCodecInfo, $($encoderParams))
            $bmp.dispose()
            return (gci $dest)
        }else {

            return $false
        }#end if
        
    }#end process
}#end function


