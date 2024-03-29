<#=========================
    parsing system.json
=========================#>
[System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$json = gc "C:\users\FANTON-21126\downloads\systems.json"
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$ser.MaxJsonLength = $json.length
$systems = $ser.DeserializeObject($json)

<#=========================
    function get-distance
=========================#>
function get-distance{
    param (
        [System.object] $sys1,
        [System.object] $sys2
    )
    PROCESS {
        $x1 = [float]($sys1.x)
        $y1 = [float]($sys1.y)
        $z1 = [float]($sys1.z)
        $x2 = [float]($sys2.x)
        $y2 = [float]($sys2.y)
        $z2 = [float]($sys2.z)
        
        $dist = [Math]::sqrt([math]::Pow($x1 -$x2 , 2.0) + [math]::Pow($y1 -$y2 , 2.0) + [math]::pow($z1-$z2 , 2.0))
        return $dist

    }
}

<#=========================
    function get-distance2
=========================#>
function get-distance2{
    param (
        [String] $sys1,
        [String] $sys2
        
    )
    PROCESS {
        $sys1 = $systems |where {$_.name -eq $sys1}
        $sys2 = $systems |where {$_.name -eq $sys2}
        $x1 = [float]($sys1.x)
        $y1 = [float]($sys1.y)
        $z1 = [float]($sys1.z)
        $x2 = [float]($sys2.x)
        $y2 = [float]($sys2.y)
        $z2 = [float]($sys2.z)
        
        $dist = [Math]::sqrt([math]::Pow($x1 -$x2 , 2.0) + [math]::Pow($y1 -$y2 , 2.0) + [math]::pow($z1-$z2 , 2.0))
        return $dist

    }
}

<#=========================
    sorting systems by power
=========================#>

$delaine = $systems |where {$_.power -eq "Archon Delaine"}
$torval = $systems |where {$_.power -eq "Zemina Torval"}

<#=========================
    3 pass to find nearest pair. (very approximate, but should work)
=========================#>
$dist = 999.0
$source = $delaine[100];
#$source = $delaine | where {$_.name -eq "LTT 9821"}
$destination = $torval[0];

$torval |foreach {
    $d = get-distance $source $_
    if ($d -lt $dist){
        $destination = $_
        $dist = $d
    }
}

$delaine |foreach {
    $d = get-distance $destination $_
    if ($d -lt $dist){
        $source = $_
        $dist = $d
    }
}

$torval |foreach {
    $d = get-distance $source $_
    if ($d -lt $dist){
        $destination = $_
        $dist = $d
    }
}

#yay! 
write-host ("{0} et {1} sont distants de {2:#.##} ly" -f $source.name,$destination.name,$dist)


<#=========================
    Doing all math ! (time ?)
=========================#>
$torval | foreach {
    $_.add('nearest',"")
    $_.add('nearestd', 99999.0)
    
    for ($i=0;$i -lt $delaine.count;$i++){
        $d = get-distance $_ $delaine[$i]
    
        if ($d -lt $_.nearestd){
            $_.nearestd = $d
            $_.nearest = $delaine[$i]
        }
        
    }
    write-host $_.name
}

##top 5
$torval.getEnumerator() |sort {$_.nearestd} |select -first 5 |foreach {
    write-host ("{0} => {1}   ({2:#.##} ly)" -f $_.nearest.name, $_.name, $_.nearestd)
}
