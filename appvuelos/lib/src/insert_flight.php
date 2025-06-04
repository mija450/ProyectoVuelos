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

// Verifica si la conexión fue exitosa
if ($conn->connect_error) {
    die(json_encode(["success" => false, "error" => "Connection failed: " . $conn->connect_error]));
}

// Verifica si la solicitud es un POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    // Verifica si se recibieron datos JSON
    if (!$data) {
        die(json_encode(["success" => false, "error" => "No se recibieron datos JSON."]));
    }

    // Obtiene los datos del JSON y verifica si están presentes
    $flight_number = $data['flight_number'] ?? null;
    $departure_airport_id = isset($data['departure_airport_id']) ? intval($data['departure_airport_id']) : null;
    $arrival_airport_id = isset($data['arrival_airport_id']) ? intval($data['arrival_airport_id']) : null;
    $departure_time = $data['departure_time'] ?? null;
    $arrival_time = $data['arrival_time'] ?? null;
    $price = isset($data['price']) ? floatval($data['price']) : null;
    $seats_available = isset($data['seats_available']) ? intval($data['seats_available']) : null;
    $airline_id = isset($data['airline_id']) ? intval($data['airline_id']) : null;

    // Validar el formato de las fechas
    $date_format = 'Y-m-d H:i:s';
    $is_departure_time_valid = DateTime::createFromFormat($date_format, $departure_time) !== false;
    $is_arrival_time_valid = DateTime::createFromFormat($date_format, $arrival_time) !== false;

    // Verifica si todos los datos requeridos están presentes
    if ($flight_number && $departure_airport_id !== null && $arrival_airport_id !== null && 
        $is_departure_time_valid && $is_arrival_time_valid && $price !== null && 
        $seats_available !== null && $airline_id !== null) {
        
        // Prepara la consulta SQL
        $sql = "INSERT INTO flights (flight_number, departure_airport_id, arrival_airport_id, 
                departure_time, arrival_time, price, seats_available, airline_id) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                
        $stmt = $conn->prepare($sql);

        // Verifica si la preparación fue exitosa
        if ($stmt) {
            $stmt->bind_param("siissdii", $flight_number, $departure_airport_id, 
                $arrival_airport_id, $departure_time, $arrival_time, $price, 
                $seats_available, $airline_id);

            // Ejecuta la consulta y devuelve el resultado
            $result = $stmt->execute();
            echo json_encode(["success" => $result]);
            $stmt->close();
        } else {
            echo json_encode(["success" => false, "error" => "Error al preparar la consulta."]);
        }
    } else {
        $error_message = "Faltan datos requeridos.";
        if (!$is_departure_time_valid || !$is_arrival_time_valid) {
            $error_message .= " Las fechas deben estar en formato YYYY-MM-DD HH:MM:SS.";
        }
        echo json_encode(["success" => false, "error" => $error_message]);
    }
}

$conn->close();
?>