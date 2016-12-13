$list = @(1 ,2 ,3 ,4 ,5 ,6)


function getMultiples($number,$list){
    $result = @() #result is an ARRAY !
    $list |foreach {if ($_%$number -eq 0) {$result += $_}}
    return $result 
}

$twos = getMultiples 2 $list # I'm an Array  
$six  = getMultiples 6 $list # I'm an Int !

$twos.getType().Name
$six.getType().Name

$twos |foreach {$_+1}
$six |foreach {$_+1} #fonctionne