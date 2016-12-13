$masque = "S116901D"
$presents = @()

for ($i=0 ; $i -le 200 ; $i++){
    $computerName = "{0}{1}" -f $masque , $i.ToString("0000000")
    if (test-connection($computerName) -Count 1 -Delay 2 -Quiet){
        $presents += $computerName
    }
   
}
$presents.count
#tourne en 500 secondes

