<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

function dbconnection() {
    $con = mysqli_connect("localhost", "root", "", "flight_booking");
    if (!$con) {
        die(json_encode(['success' => false, 'error' => mysqli_connect_error()]));
    }
    return $con;
}

// Conexión a la base de datos
$conn = dbconnection();

// Obtener el número de vuelo del cuerpo de la solicitud
$data = json_decode(file_get_contents("php://input"), true);
$flight_number = mysqli_real_escape_string($conn, $data['flight_number']);

// Consulta para buscar el vuelo
$sql = "SELECT * FROM flights WHERE flight_number = '$flight_number'";
$result = $conn->query($sql);

$flights = [];

if ($result->num_rows > 0) {
    // Salida de cada fila
    while ($row = $result->fetch_assoc()) {
        $flights[] = $row;
    }
}

// Cierra la conexión
$conn->close();

// Devolver resultados en formato JSON
echo json_encode(['success' => true, 'data' => $flights]);
?>