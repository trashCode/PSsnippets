#$urlresolution = "http://gediff.cnamts.fr/glpi/front/ticket.php?is_deleted=0&field%5B0%5D=8&searchtype%5B0%5D=equals&contains%5B0%5D=14819&link%5B1%5D=AND&field%5B1%5D=17&searchtype%5B1%5D=morethan&_select_contains%5B1%5D=0&contains%5B1%5D=2015-02-01+00%3A00%3A00&link%5B2%5D=AND&field%5B2%5D=17&searchtype%5B2%5D=lessthan&_select_contains%5B2%5D=0&contains%5B2%5D=2015-03-01+00%3A00%3A00&itemtype=Ticket&start=0&_glpi_csrf_token=ee2492f15cf641177e92cb061543c97c"
$urlresolution = "http://gediff.cnamts.fr/glpi/front/ticket.php?is_deleted=0&_select_contains[1]=0&_select_contains[2]=0&itemtype=Ticket&_glpi_csrf_token=a9a93b81f8916e22a705155749b6d18c&glpisearchcount=3&glpisearchcount2=0&field[0]=8&field[1]=17&field[2]=17&searchtype[0]=equals&searchtype[1]=morethan&searchtype[2]=lessthan&contains[0]=14819&contains[1]={0}%2000%3A00%3A00&contains[2]={1}%2000%3A00%3A00&link[1]=AND&link[2]=AND&reset=reset"
$urlOuverture =  "http://gediff.cnamts.fr/glpi/front/ticket.php?is_deleted=0&field%5B0%5D=8&searchtype%5B0%5D=equals&contains%5B0%5D=14819&link%5B1%5D=AND&field%5B1%5D=15&searchtype%5B1%5D=morethan&_select_contains%5B1%5D=0&contains%5B1%5D={0}+00%3A00%3A00&link%5B2%5D=AND&field%5B2%5D=15&searchtype%5B2%5D=lessthan&_select_contains%5B2%5D=0&contains%5B2%5D={1}+00%3A00%3A00&itemtype=Ticket&start=0&_glpi_csrf_token=6f055ee5faa6625991290c3a8aa82a9e"
$ie = "C:\Program Files\Internet Explorer\iexplore.exe"

#1 point de depart : le premier jour du mois en cours.
$month = (get-date).month

$s=get-date -year 2015 -month $month -day 1
$e=get-date -year 2015 -month (($month-1)%12) -day 1

for($i=-12+12;$i -le 0;$i++){
    & $ie ($urlOuverture -f ($e.addMonths($i)).toString("yyyy-MM-dd"),($s.addMonths($i)).toString("yyyy-MM-dd") );
    ($s.addMonths($i)).toString("yyyy-MM-dd")
    ($e.addMonths($i)).toString("yyyy-MM-dd")
    write-host ===
    start-sleep 4
}
