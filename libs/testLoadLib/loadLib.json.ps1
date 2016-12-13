$json = "{""Name"": ""Apple"",  
           ""Price"": 3.99,  
            ""Sizes"": [    
                 ""Small"",    
                 ""Medium"",
                 ""Large""]}"
                 
$currentPath ="C:\Users\FANTON-21126\Documents\powershell snipets\libs\testLoadLib"
                 
[Reflection.Assembly]::LoadFile("$currentPath\Newtonsoft.Json.dll”)