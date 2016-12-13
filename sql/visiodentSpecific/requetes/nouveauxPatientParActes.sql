select count(*) from (
select indexpatient,min(datedelacte) as premierActe from tblactesspo group by indexpatient
) as actes where premierActe <= 42369 and premierActe >= 42005