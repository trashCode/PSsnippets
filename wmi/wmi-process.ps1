$cns = @("s116901d0000067","s116901d0000069","s116901d0000072")
$servers = @("w11690100sof","w11690100ssf","w11690100snf","w11690100spf","w11690100srf","w11690100sqf","w11690100stf")
$clients = @('S116901D0000016','S116901D0000051','S116901D0000052','S116901D0000053','S116901D0000054','S116901D0000058','S116901D0000063','S116901D0000069','S116901D0000098','S116901D0000060','S116901D0000064','S116901D0000065','S116901D0000066','S116901D0000067','S116901D0000068','S116901D0000071','S116901D0000072','S116901D0000076','S116901D0000078')

$procs = get-wmiObject -query "select ProcessID,name,CSName from Win32_Process where name='visiodent.exe'" -comp $clients

foreach ($p in $procs){
    if($p.Name -eq 'visiodent.exe'){
        echo $p.CSName
    }
}

echo('EOF')