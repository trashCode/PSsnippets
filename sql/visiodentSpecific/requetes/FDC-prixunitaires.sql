SELECT 
plan,
indexacte,
indexpatient,
datedelacte,
codesecu,
indexfeuillehonoraire,
prixunitaire,
montant
FROM tblactesspo
WHERE codesecu = 'FDC' 
AND montant not in (1225000,2675000,5555000,7005000,4105000,8455000)