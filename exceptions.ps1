@"
=========================================
demonstration du mecanisme des exceptions
en powershell
=========================================

"@

function good(){
    echo("good !")
}

function bad(){
    sdflkmghsdfljkh
}

try {
    good #est executé
    bad  #plante
    good #n'est pas executé
}catch [System.Management.Automation.CommandNotFoundException]{
    echo("ca c'est mal passsé , j'arrete la")
    #$error
}catch{
}