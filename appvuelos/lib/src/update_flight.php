<?php
include("dbconnection.php");
$con = dbconnection();

header('Access-Control-Allow-Origin: *'); 
header('Access-Control-Allow-Methods: POST, GET, OPTIONS'); 
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if (isset($_POST["id"]) && isset($_POST["flight_number"]) && isset($_POST["departure_time"]) && isset($_POST["arrival_time"]) && isset($_POST["price"])) {
    $id = $_POST["id"];
    $flight_number = $_POST["flight_number"];
    $departure_time = $_POST["departure_time"];
    $arrival_time = $_POST["arrival_time"];
    $price = $_POST["price"];

    // Actualizar consulta
    $query = "UPDATE flights SET flight_number='$flight_number', departure_time='$departure_time', arrival_time='$arrival_time', price='$price' WHERE id='$id'";
    $exe = mysqli_query($con, $query);
    $arr = [];
    if ($exe) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
        $arr["error"] = mysqli_error($con);
    }
    header('Content-Type: application/json');
    print(json_encode($arr));
} else {
    echo json_encode(["success" => "false", "error" => "Datos incompletos"]);
}
?>