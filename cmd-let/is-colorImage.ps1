#Add-Type -AssemblyName System.Drawing
function is-colorImage {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {
        #pour greyscale : Format8bppIndexed
        if ( (new-object System.Drawing.Bitmap($file.fullname)).pixelFormat -eq "Format24bppRgb" ){
            return $true
        }else {
            return $false
        }
        
    }#end process
}#end function
