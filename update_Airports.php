<?php
include("dbconnection.php"); // Incluir conexión a la base de datos
$con = dbconnection();

if (isset($_POST["id"]) && isset($_POST["name"]) && isset($_POST["city"]) && isset($_POST["country"]) && isset($_POST["code"])) {
    $id = $_POST["id"];
    $name = $_POST["name"];
    $city = $_POST["city"];
    $country = $_POST["country"];
    $code = $_POST["code"];

    // Consulta para actualizar el aeropuerto
    $query = "UPDATE `airports` SET `name`='$name', `city`='$city', `country`='$country', `code`='$code' WHERE `id`='$id'";
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
