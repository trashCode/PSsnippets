#
# par defaut, get-process envois beaucoup d'info.
# on peu garde seulement les colonnes choisie en parsant son resultat dans un dataTable
# 
#Note : de facon interractive, on arrive presque au meme resultat avec un get-process|%{$_.id,$_.processName}
#



$dt = New-Object System.Data.Datatable "MyTableName"
$dt.Columns.Add("Id")
$dt.Columns.Add("ProcessName")
Get-Process | %{ $row = $dt.NewRow(); $row["Id"]=$_.Id; $row["ProcessName"]=$_.ProcessName; $dt.Rows.Add($row)}

$dt
$dt.WriteXml("d:\Processes.xml")