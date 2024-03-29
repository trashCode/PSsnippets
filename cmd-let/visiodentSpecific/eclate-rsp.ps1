##
##show-rsp: a basic RSP viewer !
##

function eclate-rsp {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [system.io.fileinfo]$file,
        
        [parameter(Mandatory=$false)]
        [alias("PF")]
        [switch]$pingfirst
        
    )
    PROCESS {
        <#
        write-output("-"*$file.name.length)
        Write-output $file.name
        write-output("-"*$file.name.length)
        #>
        $table = (gc $file.fullname).split("@")
        
        $liste = @()
        $ref = $table[0].substring(61,3)
        for ($i = 0 ; $i -lt $table.count ; $i++){
            $entite = $table[$i].substring(0,3)
            
            if ($entite -ne "000" -and $entite -ne "999"){
                $niveau = $table[$i].substring(3,2)
            }else{
              
                $niveau = "01"
            }#end if
            
            $data = $table[$i].substring(5 , $table[$i].length - 5)
            $liste += New-Object -TypeName PSobject -Property @{ file = $file; ref = $ref; numero = $i; niveau = $niveau ; entite = $entite ; data = $data} #ok !
        }#end for
        
        return $liste
    
    }
}

<#
$files = gci "\\w11690100stf\WVISIO32\Data\BaseCommune\Retours\RSP\69079187" |where {$_.lastWriteTime -gt (get-date).adddays(-4)}
$eclats = $files |eclate-rsp
$lots = $eclats | where {$_.entite -eq "080"} |foreach {$_.data.substring(6,3)}
$factures = $eclats |where {$_.entite -eq "100"}
#>