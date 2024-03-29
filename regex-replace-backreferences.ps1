'abc' -replace 'a(\w)', '$1'
#resultat : bc
$explication =@"
In your example the regex a(\w) is matching the letter 'a' 
and then a word character captured in back reference #1.
So when you replace with $1 you are replacing the matched 
text ab with back reference match b. So you get bc.
"@


'abc' -replace 'a(\w)', "$1"
#resultat : c
$explication =@"
In your second example with using double quotes PowerShell interprets "$1" 
as a string with the variable $1 inside. You don't have a variable named $1
 so it's null. So the regex replaced ab with null which is why you only get c
"@


#repetition : 
'190' -match "[0-9][0-9][0-9]" #True
'190' -match "[0-9]{3}" #True

#no match
'1a0' -notmatch "[0-9][0-9][0-9]" #True