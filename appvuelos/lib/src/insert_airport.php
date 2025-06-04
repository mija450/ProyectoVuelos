<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include("dbconnection.php");
$con = dbconnection();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));

    $name = $data->name ?? null;
    $city = $data->city ?? null;
    $country = $data->country ?? null;
    $code = $data->code ?? null;

    if (empty($name) || empty($city) || empty($country) || empty($code)) {
        echo json_encode(["success" => false, "error" => "Todos los campos son obligatorios."]);
        exit;
    }

    $query = "INSERT INTO airports(name, city, country, code) VALUES (?, ?, ?, ?)";
    $stmt = $con->prepare($query);
    if ($stmt === false) {
        echo json_encode(["success" => false, "error" => "Error en la preparación de la consulta: " . mysqli_error($con)]);
        exit;
    }

    $stmt->bind_param("ssss", $name, $city, $country, $code);

    if ($stmt->execute()) {
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false, "error" => $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["success" => false, "error" => "Método no permitido."]);
}

mysqli_close($con);
?>