function get-pixelDepth {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {
        $image = new-object -comObject Wia.ImageFile
        
        $image.LoadFile($file.fullname)
        return $image.pixelDepth
        
    }#end process
}#end function