$myinvocation.Scriptname #renvois le full path
$myinvocation.Mycommand.Name #renvois le nom du fichier.
$MyInvocation.MyCommand.Definition
$d= $MyInvocation
function test {
    echo($myinvocation.Mycommand.Name) #le nom de la commande
}

test 