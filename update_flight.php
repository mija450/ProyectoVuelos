<?php
include("dbconnection.php"); // Incluir conexión a la base de datos
$con = dbconnection();

if (isset($_POST["id"]) && isset($_POST["flight_number"]) && isset($_POST["departure_time"]) && isset($_POST["arrival_time"]) && isset($_POST["price"])) {
    $id = $_POST["id"];
    $flight_number = $_POST["flight_number"];
    $departure_time = $_POST["departure_time"];
    $arrival_time = $_POST["arrival_time"];
    $price = $_POST["price"];

    // Consulta para actualizar el vuelo
    $query = "UPDATE `flights` SET `flight_number`='$flight_number', `departure_time`='$departure_time', `arrival_time`='$arrival_time', `price`='$price' WHERE `id`='$id'";
    $exe = mysqli_query($con, $query);
    $arr = [];

    if ($exe) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
        $arr["error"] = mysqli_error($con); // Capturar error de MySQL
    }

    header('Content-Type: application/json'); // Especificar respuesta JSON
    echo json_encode($arr);
} else {
    // Retornar un error si no se reciben los datos necesarios
    echo json_encode(["success" => "false", "error" => "Datos incompletos"]);
}
?>
