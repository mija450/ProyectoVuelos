<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flight_booking";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "error" => "Connection failed: " . $conn->connect_error]));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!$data) {
        die(json_encode(["success" => false, "error" => "No se recibieron datos JSON."]));
    }

    $codigo_vuelo = $data['codigo_vuelo'] ?? null;
    $estado = $data['estado'] ?? null;
    $cambio_hora = $data['cambio_hora'] ?? null;
    $razon = $data['razon'] ?? null;

    if ($codigo_vuelo && $estado && $cambio_hora && $razon) {
        $sql = "INSERT INTO HistorialVuelo (codigo_vuelo, estado, cambio_hora, razon) VALUES (?, ?, ?, ?)";
        
        $stmt = $conn->prepare($sql);

        if ($stmt) {
            $stmt->bind_param("ssss", $codigo_vuelo, $estado, $cambio_hora, $razon);

            $result = $stmt->execute();
            echo json_encode(["success" => $result]);
            $stmt->close();
        } else {
            echo json_encode(["success" => false, "error" => "Error al preparar la consulta."]);
        }
    } else {
        echo json_encode(["success" => false, "error" => "Faltan datos requeridos."]);
    }
}

$conn->close();
?>