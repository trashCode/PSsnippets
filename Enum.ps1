#trouver les valeures d'une enumeration 
[Enum]::GetNames( [System.DayOfWeek] )

write-host("========");

[Enum]::GetNames( [System.IO.fileMode] )
write-host("========");

[Enum]::getNames([System.consoleColor])

