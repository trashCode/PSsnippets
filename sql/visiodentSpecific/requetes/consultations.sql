select indexacte,
       tbllespatients.indexpatient,
       nompatient,
       prenompatient,
       datedelacte,
       nompraticien,
       prenompraticien, 
       tblactesspo.indexpraticien,
       montant,
       libelleacte, 
       codesecu
from tblactesspo 
	inner join tblpraticiens
	on tblpraticiens.indexpraticien = tblactesspo.indexpraticien
        inner join tbllespatients 
        on tbllespatients.indexpatient = tblactesspo.indexpatient
where datedelacte > 42005 and codesecu = 'C';
