#custom powershell object 
$greg = new-object PSObject
$greg | Add-Member -type noteProperty  -Name nom -Value "greg"
$greg | Add-Member -type noteProperty  -Name Bureau -Value "informatique"

$elodie = new-object PSObject
$elodie | Add-Member -type noteProperty  -Name nom -Value "elodie"
$elodie | Add-Member -type noteProperty  -Name Bureau -Value "informatique"


$patrick = new-object PSObject
$patrick  | Add-Member -type noteProperty  -Name nom -Value "patrick Ducruet"
$patrick  | Add-Member -type noteProperty  -Name Bureau -Value "Bureau responsable declic"


$liste = ($greg,$patrick,$elodie)
$liste |where {$_.bureau -eq "informatique"}

$patrick.nom = "pat"
$liste |where {$_.nom -eq "pat"}

$greg | Add-Member -type noteProperty  -Name emploi -Value "gestionnaire informatique"
$liste #emploi ajouté a toute les colones


#autre facon de creer un object : 
#source interresasnte : http://www.powershellmagazine.com/2013/02/04/creating-powershell-custom-objects/
$properties = @{
   nom="florent";
   bureau = "bureau RDU"
}

$florent = new-object -TypeName PSObject -Property $properties

$liste +=  $florent 
$liste
$florent.emploi = "RDU" #NE MARCHE PAS !
$florent| Add-Member -type noteProperty  -Name emploi -Value "RDU"

$date = get-date
$greg |add-member -type DateTime -name laDate -value $date #ne marche pas !

$testObj = New-Object -TypeName PSobject -Property @{ Date = $date; Number = 23; } #ok ! 
$testObj.date.getType()


#ajout d'une methode a un PSobject
$a = "11 22 33 44 55"
$a = Add-Member -InputObject $a -MemberType ScriptMethod -Name explose -Value {$this.split()} -PassThru
$a.explose()


function displayPhoneNumber($phone){
    $phone = $phone.toString()
    $rs =""
    for($i = 0 ; $i -lt $phone.length ;$i++){
        $rs += $phone[$i]
        if ($i%2 -eq 1){$rs+=" "}
    }
    return $rs
}


$function1 = {
    Param([string]$phone = "aabb")
    $rs =""
    for($i = 0 ; $i -lt $phone.length ;$i++){
        $rs += $phone[$i]
        if ($i%2 -eq 1){$rs+=" "}
    }
    write 'ok'
    return $rs
}

#ajout d'une methode externe a un PSObject

$b="11224433"
$b = Add-Member -InputObject $b -MemberType ScriptMethod -Name phoneDisplay -Value $function1 -PassThru
$b.phoneDisplay()