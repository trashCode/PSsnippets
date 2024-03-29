#Option de fermeture capot : 
$NeRienfaire = 0
$Veille = 1
$VeilleProlongee = 2
$arret = 3
$HiSpeedStart = 4

#recuperer le GUID du plan d'alimentation actif
$activePlan = gwmi -NS root\cimv2\power -class Win32_powerplan |where {$_.isactive -eq "True"}
$activePlanGuid = $activePlan.InstanceID.substring(20)

#recuperer le GUID du parametre "action sur fermeture capot
$setting = gwmi -NS root\cimv2\power -class Win32_powersetting |where {$_.ElementName -eq "Action à la fermeture du capot"}
$settingGuid = $setting.InstanceId.substring(23)

#Les données sont stocké dans la classe Win32_powersettingdataindex
#l'instance ID est de la forme  : {GUID plan}/AC/{GUID parametre} ou {GUID plan}/DC/{GUID parametre}
#on change les deux parametres pour AC et DC
#Note : je sais pas d'ou sort cette methode put(), mais ca marche.
$data = gwmi -NS root\cimv2\power -class Win32_powersettingdataindex |where {$_.InstanceId -like "*$settingGuid*" -and $_.InstanceId -like "*$activePlanGuid*" }
$data[0].SettingIndexValue = $NeRienfaire
$data[0].put()
$data[1].SettingIndexValue = $NeRienfaire
$data[1].put()

$data1 = gwmi -NS root\cimv2\power -class Win32_powersettingdataindex
$data2 = gwmi -NS root\cimv2\power -class Win32_powersettingdataindex