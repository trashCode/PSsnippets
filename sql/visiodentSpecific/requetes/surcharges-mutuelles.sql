select tblparamactestp.indexacteparametre,codeacte,libellemutuelle,numerotransmission
from tblparamactestp 
inner join tblparamactes
  on tblparamactestp.indexacteparametre = tblparamactes.indexacteparametre
inner join tblmutuelle 
  on tblparamactestp.indexmutuelle = tblmutuelle.indexmutuelle  
where tblparamactes.codeacteccam != ''