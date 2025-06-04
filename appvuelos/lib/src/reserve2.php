<?php 
header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Methods: POST, GET, OPTIONS"); 
header("Access-Control-Allow-Headers: Content-Type"); 
include 'dbconnection.php';  

if ($_SERVER['REQUEST_METHOD'] === 'POST') {     
    $user_id = $_POST['user_id'];     
    $flight_id = $_POST['flight_id'];      

    $con = dbconnection();      

    // 🔍 Verificar si el usuario ya tiene una reserva para el mismo vuelo
    $check_query = "SELECT id FROM reservations WHERE user_id = '$user_id' AND flight_id = '$flight_id'";     
    $result = mysqli_query($con, $check_query);      

    if (mysqli_num_rows($result) > 0) {         
        //  Usuario ya tiene una reserva para este vuelo         
        echo json_encode([             
            "status" => "error",             
            "message" => "Ya has reservado este vuelo.",         
        ]);     
    } else {         
        //  Insertar nueva reserva si el usuario no ha reservado este vuelo
        $query = "INSERT INTO reservations (user_id, flight_id) VALUES ('$user_id', '$flight_id')";                  

        if (mysqli_query($con, $query)) {             
            echo json_encode([                 
                "status" => "success",                 
                "message" => "Reserva realizada con éxito.",             
            ]);         
        } else {             
            echo json_encode([                 
                "status" => "error",                 
                "message" => "Error al realizar la reserva.",             
            ]);         
        }     
    }          

    mysqli_close($con); 
} 
?>