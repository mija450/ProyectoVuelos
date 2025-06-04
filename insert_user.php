<?php
include 'dbconnection.php';
$con = dbconnection();

if (isset($_POST["name"]) && isset($_POST["email"]) && isset($_POST["password"])) {
    $name = $_POST["name"];
    $email = $_POST["email"];
    $password = $_POST["password"];

    // Validar el dominio del correo electrónico
    if (!preg_match('/@gmail\.com$|@hotmail\.com$/', $email)) {
        $arr["success"] = "false";
        $arr["message"] = "El correo debe ser @gmail.com o @hotmail.com";
        print(json_encode($arr));
        return;
    }

    $query = "INSERT INTO `users` (`name`, `email`, `password`) 
              VALUES ('$name', '$email', '$password')";
    $exe = mysqli_query($con, $query);

    $arr = [];
    if ($exe) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
    }
    print(json_encode($arr));
} else {
    $arr["success"] = "false";
    $arr["message"] = "Faltan datos.";
    print(json_encode($arr));
}
?>