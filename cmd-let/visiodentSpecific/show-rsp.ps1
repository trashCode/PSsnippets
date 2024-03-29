##
##show-rsp: a basic RSP viewer !
##

function show-rsp {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [system.io.fileinfo]$file,
        
        [parameter(Mandatory=$false)]
        [alias("PF")]
        [switch]$pingfirst
        
    )
    PROCESS {
        write-output("-"*$file.name.length)
        Write-output $file.name
        write-output("-"*$file.name.length)
        $table = (gc $file.fullname).split("@")
        
        $liste = @()
        for ($i = 0 ; $i -lt $table.count ; $i++){
            $entite = $table[$i].substring(0,3)
            
            if ($entite -ne "000" -and $entite -ne "999"){
                $niveau = $table[$i].substring(3,2)
            }else{
                $niveau = "01"
            }#end if
            
            $data = $table[$i].substring(5 , $table[$i].length - 5)
            $liste += New-Object -TypeName PSobject -Property @{ numero = $i; niveau = $niveau ; entite = $entite ; data = $data} #ok !
        }#end for
        
        $liste |foreach {
            $spaces = [Math]::min(3 * [int]($_.niveau) , 18)
            $spaces2 = 24 - $spaces
            $taille  = [Math]::min($_.data.length , 60)
            write-output ( "{0}{1}{2}{3}{4}" -f $_.numero.toString().padright(3) , (" "*$spaces) , $_.entite , (" "*$spaces2) , $_.data.substring(0,$taille) )
        }#end foreach
    
    }
}