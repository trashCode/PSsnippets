$a = 2
function add5($i){
    $i = $i +5
}
add5($a)
$a
#$a vaut toujours 2 !

function refAdd5([ref]$i){#ne pas oublier le .value ! 
    $i.value = $i.value +5
}
refAdd5([ref]$a)
$a
#$a vaut 7 !