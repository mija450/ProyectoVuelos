<?php
include("dbconnection.php");
$con = dbconnection();

header('Access-Control-Allow-Origin: *'); 
header('Access-Control-Allow-Methods: POST, GET, OPTIONS'); 
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

// Obtener los datos JSON enviados desde Flutter
$data = json_decode(file_get_contents('php://input'), true);

// Verificar si se reciben todos los datos necesarios
if (isset($data["id"]) && isset($data["flight_id"]) && isset($data["status"]) && isset($data["booking_date"])) {
    $id = intval($data["id"]);
    $flight_id = intval($data["flight_id"]);
    $status = $data["status"];
    $booking_date = $data["booking_date"];

    // Validar que el estado sea correcto
    if (!in_array($status, ['confirmed', 'cancelled'])) {
        echo json_encode(["success" => "false", "error" => "Estado no válido."]);
        exit;
    }

    // Validar el formato de la fecha
    $date_format = DateTime::createFromFormat('Y-m-d H:i:s', $booking_date);
    if (!$date_format || $date_format->format('Y-m-d H:i:s') !== $booking_date) {
        echo json_encode(["success" => "false", "error" => "Formato de fecha no válido."]);
        exit;
    }

    // Verificar si el flight_id existe en la tabla de vuelos
    $checkFlightQuery = "SELECT COUNT(*) FROM flights WHERE id = ?";
    $checkStmt = $con->prepare($checkFlightQuery);
    $checkStmt->bind_param("i", $flight_id);
    $checkStmt->execute();
    $checkStmt->bind_result($count);
    $checkStmt->fetch();
    $checkStmt->close();

    if ($count == 0) {
        echo json_encode(["success" => "false", "error" => "El flight_id no existe en la tabla de vuelos."]);
        exit;
    }

    // Utilizar una consulta preparada para evitar inyecciones SQL
    $query = "UPDATE reservations SET flight_id=?, status=?, booking_date=? WHERE id=?";
    $stmt = $con->prepare($query);
    
    if ($stmt) {
        // Vincular parámetros
        $stmt->bind_param("issi", $flight_id, $status, $booking_date, $id);
        
        // Ejecutar la consulta
        if ($stmt->execute()) {
            echo json_encode(["success" => "true"]);
        } else {
            echo json_encode(["success" => "false", "error" => "Error al ejecutar la consulta: " . $stmt->error]);
        }
        $stmt->close();
    } else {
        echo json_encode(["success" => "false", "error" => "Error en la preparación de la consulta: " . $con->error]);
    }
} else {
    echo json_encode(["success" => "false", "error" => "Datos incompletos"]);
}

// Cerrar conexión
$con->close();
?>