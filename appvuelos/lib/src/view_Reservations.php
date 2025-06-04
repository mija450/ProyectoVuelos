<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include("dbconnection.php");

$con = dbconnection();
$query = "SELECT id, user_id, flight_id, booking_date, status FROM reservations";
$exe = mysqli_query($con, $query);
$arr = [];

if ($exe) {
    while ($row = mysqli_fetch_assoc($exe)) {
        $arr[] = $row;
    }
    echo json_encode($arr); 
} else {
    echo json_encode(["success" => false, "error" => mysqli_error($con)]);
}

mysqli_close($con);
?>