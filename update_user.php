<?php
include("dbconnection.php");
$con = dbconnection();

if (isset($_POST["id_user"]) && isset($_POST["name"]) && isset($_POST["email"])) {
    $id_user = $_POST["id_user"];
    $name = $_POST["name"];
    $email = $_POST["email"];

    // Actualizar consulta
    $query = "UPDATE `users` SET `name`='$name', `email`='$email' WHERE `id`='$id_user'";
    $exe = mysqli_query($con, $query);
    $arr = [];

    if ($exe) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
        $arr["error"] = mysqli_error($con); // Capturar error de MySQL
    }

    header('Content-Type: application/json'); // Especificar respuesta JSON
    print(json_encode($arr));
} else {
    // Retornar un error si no se reciben los datos necesarios
    echo json_encode(["success" => "false", "error" => "Datos incompletos"]);
}
?>
