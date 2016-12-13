#approche weberquest
$request = [System.Net.WebRequest]::Create("http://sebsauvage.net/links/")
$request.Credentials = $account
$response = $request.getResponse()
$stream = $response.GetResponseStream()

<# ne marche pas ? a creuser.
$xmlReader = new-object system.xml.xmlTextReader($stream)
#>

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

$articles = $doc.documentNode.selectnodes("/html/body/div[@id='linklist']/ul/li")
$articles2 = $doc.documentNode.selectnodes("//div[@class='linkcontainer']")#plus simple, un cran plus loin.
$articles2|foreach {
    $text = $_.ChildNodes[1].InnerText
    $link = $_.ChildNodes[1].ChildNodes[0].Attributes["href"].Value
    $descr = $_.ChildNodes[5].innerText
    $date = $_.ChildNodes[7].innerText
    $id = $_.ChildNodes[7].firstChild.Attributes["href"].Value
    "=============================="
    $text 
    $desc
    $link
    $date
    $id
}




#approche xmlDocument (requiert HTML bien formé)
$xmlDoc = new-object system.xml.XmlDocument
$xmlDoc.loadxml($content)


#approche webclient
$url = "http://gregfan.free.fr/SV/demontage%20carbu%2017-09/"
$client = new-object system.net.webclient
$client.proxy.getProxy("$url")
#$secureString = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR("$U<h86X$"))
$secureString = [System.Security.SecureString]

#static
$account = new-object System.Net.NetworkCredential("FANTON-21126",'$U<h86X$')
$client.proxy.credentials = $account

#interractive
#$client.proxy.credentials = get-credential

$content = $client.downloadString($url)

$html = [System.Net.WebUtility]::HTMLDecode($content)