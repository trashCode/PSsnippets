$masque = "S116901D"
$presents = @()

for ($i=0 ; $i -le 200 ; $i+=10){
    $test = "{0}{1}" -f $masque , $i.ToString("0000000")
    $test1 = "{0}{1}" -f $masque , ($i+1).ToString("0000000")
    $test2 = "{0}{1}" -f $masque , ($i+2).ToString("0000000")
    $test3 = "{0}{1}" -f $masque , ($i+3).ToString("0000000")
    $test4 = "{0}{1}" -f $masque , ($i+4).ToString("0000000")
    $test5 = "{0}{1}" -f $masque , ($i+5).ToString("0000000")
    $test6 = "{0}{1}" -f $masque , ($i+6).ToString("0000000")
    $test7 = "{0}{1}" -f $masque , ($i+7).ToString("0000000")
    $test8 = "{0}{1}" -f $masque , ($i+8).ToString("0000000")
    $test9 = "{0}{1}" -f $masque , ($i+9).ToString("0000000")
    $presents += test-connection $test,$test1,$test9 -Count 1 -delay 1
}
