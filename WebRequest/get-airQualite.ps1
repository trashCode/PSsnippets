#approche weberquest
$request = [System.Net.WebRequest]::Create("http://www.air-rhonealpes.fr/monair/commune/69123")

$account = new-object System.Net.NetworkCredential("FANTON-21126",'$U<h86X$')
#$account = get-credential

#$request.Credentials = $account  #ceci n'est pas le login du proxy.
$request.proxy.credentials = $account #ceci EST le login du proxy! 
$request.timeout = 600
$response = $request.getResponse()
$stream = $response.GetResponseStream()

<# StreamREADER produisant un string #>
$reader = new-object system.IO.StreamReader($stream)
$content = $reader.ReadToEnd();
$reader.close()
$reader.dispose()
$stream.close()
$stream.dispose()



add-type -Path "C:\Users\FANTON-21126\Documents\powershell snipets\HtmlAgilityPack\Net20\HtmlAgilityPack.dll"
$doc = New-Object HtmlAgilityPack.HtmlDocument 
$result = $doc.LoadHtml($content) 

$echelle = $doc.documentNode.selectnodes("//ul[@class='city-legend-list']")
$indices = $echelle[0].selectnodes("./li")
if ($indices.count -ne 10){
    #Houston, we have a problem
}else{
    
    for($i=0;$i -lt 10 ; $i++){
     if ($indices[$i].attributes["class"].Value -eq "prevision-indice-active"){
        $indice=$i+1;
        $color = $indices[$i].attributes["style"].Value.substring(18)
        $i+=10 #on sort du fort
     }
    }
}

$indice
$color 