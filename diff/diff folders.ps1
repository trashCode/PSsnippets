#Attention, lastWriteTime sur les dossiers ne permet pas grand chose...

diff $cle $cle2 -property Name,LastWriteTime,PSiscontainer |where-object {!$_.PSiscontainer}|sort-object -property Name