function detailFactory($nom , $mobile){
    $detail = new-Object -TypeName PSobject -Property @{ numAgent = "greg"; mobile = "06 01 02 03 04"}
    return $detail
}

$test = detailFactory "greg" , "11 22 33 44 55"

$test.numAgent