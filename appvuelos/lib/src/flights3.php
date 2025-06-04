<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
include 'dbconnection.php';

$con = dbconnection();

// Modificación de la consulta para incluir los nombres de los aeropuertos
$query = "
    SELECT f.id, f.flight_number, f.price, f.seats_available, 
           a1.name AS departure_airport, a2.name AS arrival_airport 
    FROM flights f
    JOIN airports a1 ON f.departure_airport_id = a1.id
    JOIN airports a2 ON f.arrival_airport_id = a2.id
";
$result = mysqli_query($con, $query);

$flights = [];
while ($row = mysqli_fetch_assoc($result)) {
    $flights[] = $row;
}

echo json_encode($flights);

mysqli_close($con);
?>