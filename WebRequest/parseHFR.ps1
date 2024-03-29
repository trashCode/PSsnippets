#requis pour parsing html.
add-type -Path "C:\Users\FANTON-21126\Documents\powershell snipets\HtmlAgilityPack\Net20\HtmlAgilityPack.dll"

#fonction de conversion de date : HFR Last Response Date
function convertHFRdate($inputString){
    return get-date($inputString -replace "([0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]).*([0-9][0-9]:[0-9][0-9])",'$1 $2')
}

#approche webclient
$client = new-object system.net.webclient
$client.encoding = new-object system.text.utf8encoding
$secureString = [System.Security.SecureString]

#static auth
$account = new-object System.Net.NetworkCredential("FANTON-21126",'$U<h86X$')
$client.proxy.credentials = $account




<#
parseListeHFR :
in : string htmlContent (du code html)
out : PSCustomObject[] tableau de sujets 
#>
function parseListeHFR($htmlContent){
    $doc = New-Object HtmlAgilityPack.HtmlDocument 



    $result1 = $doc.LoadHtml($htmlContent)


    $htmlsujets = $doc.documentNode.selectnodes('//tr[contains(@class,''sujet'')]')
    $sujets = @()


    $htmlsujets |foreach {
        
        <#
            $_.childNode[4] est le td sujetCase3 (titre + lien)
            $_.childNode[5] est le td sujetCase4 (nb Pages)
            $_.childNode[7] est le td sujetCase6 (auteur)
            $_.childNode[9] est le td sujetCase7 (nb reponses)
            $_.childNode[11] est le td sujetCase8 (nb lectures)
            $_.childNode[13] est le td sujetCase9 (date dernier message + auteur)
        #>
        
        <#
        $titre = $_.childNodes[4].selectnodes('a[1]')[0].innerText
        $url = $_.childNodes[4].selectnodes('a[1]')[0].attributes["href"].value
        $auteur = $_.childNodes[7].innertext
        $nbReponses = $_.childNodes[9].innertext
        $nbVues = $_.childNodes[11].innertext
        $lastResponseDate = $_.childNodes[13].childNodes[0].childNodes[0].innerText
        $lastResponseAuteur = $_.childNodes[13].childNodes[0].childNodes[2].innerText
        #>

        $properties = @{
            titre = $_.childNodes[4].selectnodes('a[1]')[0].innerText
            url = "http://forum.hardware.fr" + $_.childNodes[4].selectnodes('a[1]')[0].attributes["href"].value
            auteur = $_.childNodes[7].innertext
            nbReponses = $_.childNodes[9].innertext
            nbVues = $_.childNodes[11].innertext
            lastResponseDate = convertHFRdate $_.childNodes[13].childNodes[0].childNodes[0].innerText
            lastResponseAuteur = $_.childNodes[13].childNodes[0].childNodes[2].innerText
        }
        
        $sujet = new-object -TypeName PSObject -Property $properties
        $sujets += $sujet
    }
    return $sujets
}


$urls = "http://forum.hardware.fr/hfr/AchatsVentes/Hardware/liste_sujet-1.htm",
"http://forum.hardware.fr/hfr/AchatsVentes/Hardware/liste_sujet-2.htm",
"http://forum.hardware.fr/hfr/AchatsVentes/Hardware/liste_sujet-3.htm",
"http://forum.hardware.fr/hfr/AchatsVentes/Hardware/liste_sujet-4.htm"

$contents = @();


#chargement des contenus HTML
$urls |foreach {
    $contents += $client.downloadString($_);
}

$lesSujets = @()

$contents |foreach {
    $lesSujets += parseListeHFR $_
}


$current = 0;
$max = $lesSujets.count

while ($current -ne $lesSujets.count){
    clear
    write-host("="*$lesSujets[$current].titre.length) 
    write-host($lesSujets[$current].titre) 
    write-host("="*$lesSujets[$current].titre.length) 
    
    write-host ""
    write-host("1:Previous")
    write-host("2:Details")
    write-host("3:Next")
    write-host("4:End")
    
    $reponse = read-host -Prompt "Choix "
    
    switch ($reponse){
        
        '1' {
        $current--
        if ($current -lt 0){$current = $lesSujets.count -1}
        }
        
        '2'{
            clear
            $lesSujets[$current]
            $lesSujets[$current].url |clip 
            write-host("url copiée dans le presse papier")
            $pause = read-host -prompt "enter pour continuer"
        }
        
        '3' {
            $current++
        }
        '4' {
            $current  = $lesSujets.count
        }
    }
    
}