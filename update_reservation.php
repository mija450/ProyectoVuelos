<?php
include("dbconnection.php");
$con = dbconnection();

$response = ["success" => "false"];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["id"]) && isset($_POST["status"])) {
    $id = $_POST["id"];
    $status = $_POST["status"];

    $query = "UPDATE `reservations` SET `status`=? WHERE `id`=?";
    $stmt = mysqli_prepare($con, $query);

    if ($stmt) {
        mysqli_stmt_bind_param($stmt, "si", $status, $id);
        if (mysqli_stmt_execute($stmt)) {
            $response["success"] = "true";
        } else {
            $response["error"] = mysqli_error($con);
        }
        mysqli_stmt_close($stmt);
    } else {
        $response["error"] = "Error en la preparación de la consulta";
    }
} else {
    $response["error"] = "Datos incompletos";
}

header('Content-Type: application/json');
echo json_encode($response);
?>

