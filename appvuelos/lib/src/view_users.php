<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include("dbconnection.php");

$con = dbconnection();
$query = "SELECT id, name, email FROM users";
$exe = mysqli_query($con, $query);
$arr = [];

while ($row = mysqli_fetch_assoc($exe)) { 
    $arr[] = $row;
}

echo json_encode($arr);
?>