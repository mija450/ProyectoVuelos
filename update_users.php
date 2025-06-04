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

    // Actualizar consulta
    $query = "UPDATE users SET name='$name', email='$email' WHERE id='$id_user'";
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