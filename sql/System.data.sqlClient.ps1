$dataSource = “.\SQLEXPRESS”
#$user = “user”
#$pwd = “1234″
$database = “parcinfo”
#$connectionString = “Server=$dataSource;uid=$user; pwd=$pwd;Database=$database;Integrated Security=False;”
#$WSHconnctionString= "driver={SQL Server};server=w11690100sbf; database=parcinfo"
$connectionString = “Server=w11690100sbf;Database=parcinfo;Integrated Security=True;”

#$connectionString = "server='w11690100sbf';database='parcinfo';trusted_connection=true;"

$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

$connection.Open()


#$query = “SELECT * FROM session WHERE (DATEDIFF(day, heure, CURRENT_TIMESTAMP) < 1)”
$query = "Select * from kiouCSD"
$command = $connection.CreateCommand()
$command.CommandText = $query

$result = $command.ExecuteReader()
$table = new-object “System.Data.DataTable”
$table.Load($result)
#$table |ogv -title "Sessions du jour"


$connection.Close()