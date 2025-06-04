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
    $flight_number = $data['flight_number'] ?? null;
    $departure_airport_id = $data['departure_airport_id'] ?? null;
    $arrival_airport_id = $data['arrival_airport_id'] ?? null;
    $departure_time = $data['departure_time'] ?? null;
    $arrival_time = $data['arrival_time'] ?? null;
    $price = $data['price'] ?? null;
    $seats_available = $data['seats_available'] ?? null;

    if ($flight_number && $departure_airport_id && $arrival_airport_id && $departure_time && $arrival_time && $price && $seats_available) {
        $sql = "INSERT INTO flights(flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time, price, seats_available) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sisssdi", $flight_number, $departure_airport_id, $arrival_airport_id, $departure_time, $arrival_time, $price, $seats_available);

        if ($stmt->execute()) {
            echo json_encode(["success" => true]);
        } else {
            echo json_encode(["success" => false, "error" => $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "error" => "Faltan datos requeridos."]);
    }
} else {
    echo json_encode(["success" => false, "error" => "Método no permitido."]);
}

$conn->close();
?>
