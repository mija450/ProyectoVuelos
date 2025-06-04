<?php
include("dbconnection.php");
$con = dbconnection();

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $name = isset($_POST["name"]) ? $_POST["name"] : null;
    $email = isset($_POST["email"]) ? $_POST["email"] : null;
    $password = isset($_POST["password"]) ? $_POST["password"] : null;

    if (!$name || !$email || !$password) {
        echo json_encode(["success" => "false", "error" => "Faltan datos requeridos.", "data" => $_POST]);
        return;
    }

    $query = "INSERT INTO users(name, email, password) VALUES ('$name','$email','$password')";
    $exe = mysqli_query($con, $query);

    $arr = [];
    if ($exe) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
        $arr["error"] = "Error al insertar en la base de datos.";
    }
    echo json_encode($arr);
} else {
    echo json_encode(["success" => "false", "error" => "Método no permitido."]);
}
?>