<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include("dbconnection.php");
$con = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Obtener datos JSON
$data = json_decode(file_get_contents("php://input"), true);

$id = $data['id'] ?? null;
$name = $data['name'] ?? null;
$city = $data['city'] ?? null;
$country = $data['country'] ?? null;
$code = $data['code'] ?? null;

// Validar que todos los campos sean proporcionados
if ($id === null || $name === null || $city === null || $country === null || $code === null) {
    echo json_encode(["success" => false, "error" => "Datos incompletos"]);
    exit();
}

// Preparar la consulta para actualizar el aeropuerto
$query = "UPDATE airports SET name=?, city=?, country=?, code=? WHERE id=?";
$stmt = $con->prepare($query);
$stmt->bind_param("ssssi", $name, $city, $country, $code, $id); // Bind parameters

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => $stmt->error]);
}

$stmt->close();
mysqli_close($con);
?>