$csd = import-csv gc-csd.csv -delimiter ';'

#tickets par technicien
$csd |group-object 'technicien'
$csd |group-object 'technicien' |select-object count,Name 

#conversion de la date d'ouverture pour requetage

$ref = get-date
$ref = $ref.addDays(-10) #on recherche les ticket de moins de 10 jours

$csd |where-object {[dateTime]::parseExact($_.ouverture , "dd/MM/yyyy HH:mm",$null) -gt $ref} |group-object demandeur |sort  count -desc