function shrink-image {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.fileinfo]$file

    )
    PROCESS {
        $executable = "C:\APPLILOC\imagemagick\convert.exe"
        $dst = $file.fullname -replace (".png" , ".jpg")
        
        #test si le fichier dest n'existe pas deja
        if( -not(test-path($dst))){
                
            Start-Process $executable -ArgumentList ($file.fullName +"/convert=$dst") -wait -NoNewWindow

            $dst = gci $dst
            $dst.creationTime = $file.creationTime
            $dst.lastWriteTime = $file.lastWriteTime
            return 0
        }else{
            write-debug( "un fichier jpg du même nom était présent." )
            return 1
        } #end if
        
    }#end process
}#end function