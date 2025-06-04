<?php
include 'dbconnection.php';

// Configuración para mostrar errores, útil para depuración
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Permitir solicitudes desde otros orígenes
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $con = dbconnection();

    // Usar declaraciones preparadas para evitar inyecciones SQL
    $stmt = $con->prepare("SELECT * FROM users WHERE email = ? AND password = ?");
    $stmt->bind_param("ss", $email, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        echo json_encode([
            "status" => "success",
            "message" => "Login successful",
            "user" => $user,
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Invalid credentials",
        ]);
    }

    $stmt->close();
    mysqli_close($con);
}
?>