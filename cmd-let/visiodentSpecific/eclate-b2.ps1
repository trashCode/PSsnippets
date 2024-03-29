##
##eclate-b2: a basic B2 parser !
##

function eclate-b2 {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [system.io.fileinfo]$file
        
    )
    PROCESS {
        $Buffer = New-Object Byte[] 128
        $line = @()
        $decoder = new-Object System.Text.ASCIIEncoding
        #$stream = [System.IO.File]::Create($file) ## /!\ DANGER : creer un stream vide : flush le fichier s'il existe deja !!

        if (test-Path $file){
            $stream = new-object System.IO.FileStream($file,[System.IO.fileMode]::open)

            Do {
                #...attemt to read one kilobyte of data from the web response stream.
                $nbBytesRead = $stream.Read($Buffer, 0 , $Buffer.Length)
                $line += $decoder.getString($buffer)
                #write ("position : {0}    octets lu : {1}" -f $stream.position,$nbBytesRead)
            } While ($nbBytesRead -gt 0)
            
            $stream.close()
        }else{
            write "unable to read file";
        }#end if
        return $line
    }#end Process
}#end function
