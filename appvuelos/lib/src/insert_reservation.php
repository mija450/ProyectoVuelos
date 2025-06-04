<?php
include("dbconnection.php");
$con = dbconnection();

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!$data) {
        echo json_encode(["success" => false, "error" => "No se recibieron datos JSON."]);
        exit;
    }

    $user_id = isset($data['user_id']) ? intval($data['user_id']) : null;
    $flight_id = isset($data['flight_id']) ? intval($data['flight_id']) : null;
    $booking_date = isset($data['booking_date']) ? date("Y-m-d H:i:s", strtotime($data['booking_date'])) : null;
    $status = $data['status'] ?? null;

    // Validar campos obligatorios
    if (!$user_id || !$flight_id || !$booking_date || !$status) {
        echo json_encode(["success" => false, "error" => "Faltan datos requeridos."]);
        exit;
    }

    // Validar estado
    if (!in_array($status, ['confirmed', 'cancelled'])) {
        echo json_encode(["success" => false, "error" => "Estado no válido."]);
        exit;
    }

    // Verificar si el vuelo existe
    $flight_check_query = "SELECT id FROM flights WHERE id = ?";
    $stmt = $con->prepare($flight_check_query);
    $stmt->bind_param("i", $flight_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["success" => false, "error" => "El vuelo no existe."]);
        exit;
    }

    // Realizar la inserción
    $sql = "INSERT INTO reservations (user_id, flight_id, booking_date, status) VALUES (?, ?, ?, ?)";
    $stmt = $con->prepare($sql);
    $stmt->bind_param("iiss", $user_id, $flight_id, $booking_date, $status);

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