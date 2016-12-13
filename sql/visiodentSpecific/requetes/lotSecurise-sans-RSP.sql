
select 
	numeroordrefacture as numFSE,
	numerolotfse as lot,
	datecreation as dateLot,
	dateenvoyer,
	datersp,
	datecreer as dateFacture,
	nomPS,
	nomassure,
	nombeneficaire,
	datenaissance,
	numeroimmatriculation,
	coderegime,
	caissegestionnaire,
	centregestionnaire,
	montanthonoraires,
	montantamo,
	montantamc,
	montantassure,
	recevoiretatfse,
	numerofacture,
	datefirstenvoi
from tblinfosfacture inner join tblinfoslot
on tblinfosfacture.numerolotfse::integer = tblinfoslot.numeroordrelot
where securiser = true 
and datersp = '000000000000'
and datecreation like '2015%'
