<?php
include("dbconnection.php");
$con = dbconnection();

header('Access-Control-Allow-Origin: *'); 
header('Access-Control-Allow-Methods: POST, GET, OPTIONS'); 
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if (isset($_POST["id_user"]) && isset($_POST["name"]) && isset($_POST["email"])) {
    $id_user = $_POST["id_user"];
    $name = $_POST["name"];
    $email = $_POST["email"];

    // Actualizar consulta usando sentencias preparadas
    $stmt = $con->prepare("UPDATE users SET name=?, email=? WHERE id=?");
    $stmt->bind_param("ssi", $name, $email, $id_user);

    $arr = [];
    if ($stmt->execute()) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
        $arr["error"] = $stmt->error;
    }

    $stmt->close();
    header('Content-Type: application/json');
    echo json_encode($arr);
} else {
    echo json_encode(["success" => "false", "error" => "Datos incompletos"]);
}
?>