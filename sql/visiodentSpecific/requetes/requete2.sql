select indexrdv,datedurdv,heuredurdv,nompraticien,prenompraticien,fauteuil,duree,commentaire from tblagenda INNER JOIN tblpraticiens ON tblpraticiens.indexpraticien = tblagenda.indexpraticien LEFT OUTER JOIN tblmemoagenda on tblagenda.indexrdv = tblmemoagenda.indexagenda where indexpatient = 0 and duree < 60  and datedurdv > 42005 order by datedurdv,nompraticien;