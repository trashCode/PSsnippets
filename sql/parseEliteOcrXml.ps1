$file = resolve-path "C:\Users\FANTON-21126\Downloads\test.xml"
#$file = resolve-path "C:\Users\FANTON-21126\Desktop\test2.xml"
[xml] $xdoc = get-content $file
$system = $xdoc.ocrresult.location.system.'#text'
$station = $xdoc.ocrresult.location.station.'#text'
$dateParsed = [system.dateTime]::parse($xdoc.ocrresult.setup.filetimestamp)
$market = $xdoc.ocrresult.market.entry

foreach ($item in $market){
    $item.commodity.'#text'
    [int]($item.sell.'#text')
    [int]($item.demand.'#text')
    $item.demandlevel.'#text'
    
    [int]($item.buy.'#text')
    [int]($item.supply.'#text')
    $item.supplylevel.'#text'
    "====================="
}