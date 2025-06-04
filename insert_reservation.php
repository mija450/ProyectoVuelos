<?php
include("dbconnection.php");
$con = dbconnection();

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $user_id = $_POST['user_id'] ?? null;
    $flight_id = $_POST['flight_id'] ?? null;
    $booking_date = $_POST['booking_date'] ?? null;
    $status = $_POST['status'] ?? null;

    if ($user_id === null || $flight_id === null || $booking_date === null || $status === null) {
        echo json_encode(["success" => false, "error" => "Faltan datos requeridos."]);
        exit;
    }

    $sql = "INSERT INTO reservations(user_id, flight_id, booking_date, status) VALUES (?, ?, ?, ?)";
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
