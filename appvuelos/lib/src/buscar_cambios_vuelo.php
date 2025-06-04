<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

function dbconnection() {
    $con = mysqli_connect("localhost", "root", "", "flight_booking");
    if (!$con) {
        die(json_encode(['success' => false, 'error' => mysqli_connect_error()]));
    }
    return $con;
}

$conn = dbconnection();

$data = json_decode(file_get_contents("php://input"), true);
$codigo_vuelo = mysqli_real_escape_string($conn, $data['codigo_vuelo']);

$sql = "SELECT codigo_vuelo, estado, razon, fecha_creacion FROM HistorialVuelo WHERE codigo_vuelo = '$codigo_vuelo' ORDER BY fecha_creacion DESC";
$result = $conn->query($sql);

$cambios = [];

if ($result) {
    if ($result->num_rows > 0) {

        while ($row = $result->fetch_assoc()) {
            $cambios[] = [
                'codigo_vuelo' => $row['codigo_vuelo'], 
                'estado' => $row['estado'],
                'razon' => $row['razon'],
                'fecha_creacion' => $row['fecha_creacion']
            ];
        }
    }
}

$conn->close();

echo json_encode(['success' => true, 'data' => $cambios]);
?>