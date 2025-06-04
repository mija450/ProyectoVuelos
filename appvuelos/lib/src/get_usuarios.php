<?php
include 'db_connection_colegio.php';

header('Content-Type: application/json');

$con = dbconnection();

if (isset($_GET['correo']) && isset($_GET['contraseña'])) {
    $correo = mysqli_real_escape_string($con, $_GET['correo']);
    $contraseña = $_GET['contraseña']; // No la escapes, se comparará con el hash

    $query = "SELECT * FROM Usuario WHERE correo = '$correo'";
    $result = mysqli_query($con, $query);
    
    if (mysqli_num_rows($result) > 0) {
        $usuario = mysqli_fetch_assoc($result);
        
        // Verificar la contraseña
        if (password_verify($contraseña, $usuario['contraseña'])) {
            echo json_encode($usuario); // Devuelve los datos del usuario
        } else {
            echo json_encode(['message' => 'Contraseña incorrecta']);
        }
    } else {
        echo json_encode(['message' => 'Este usuario no existe']);
    }
} else {
    echo json_encode(['message' => 'No se proporcionó correo o contraseña']);
}

mysqli_close($con);
?>