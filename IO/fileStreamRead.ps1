
$path = "D:\WVISIO32\data\basecommune\retours\RSP"
$file = "D:\WVISIO32\data\basecommune\retours\RSP\retour_20141003095438812.rsp"


$Buffer = New-Object Byte[] 128
$line = @()
#$stream = [System.IO.File]::Create($file) ## /!\ DANGER : creer un stream vide : flush le fichier s'il existe deja !!

if (test-Path $file){
    $stream = new-object System.IO.FileStream($file,[System.IO.fileMode]::open)

    Do {
        #...attemt to read one kilobyte of data from the web response stream.
        $nbBytesRead = $stream.Read($Buffer, 0 , $Buffer.Length)
        $line+=$buffer
        write ("position : {0}    octets lu : {1}" -f $stream.position,$nbBytesRead)
    } While ($nbBytesRead -gt 0)
    
    $stream.close()
}