<?php
include("dbconnection.php");
$con = dbconnection();

header('Access-Control-Allow-Origin: *'); 
header('Access-Control-Allow-Methods: POST, GET, OPTIONS'); 
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if (isset($_POST["id"]) && isset($_POST["name"]) && isset($_POST["city"]) && isset($_POST["country"]) && isset($_POST["code"])) {
    $id = $_POST["id"];
    $name = $_POST["name"];
    $city = $_POST["city"];
    $country = $_POST["country"];
    $code = $_POST["code"];

    // Actualizar consulta
    $query = "UPDATE airports SET name='$name', city='$city', country='$country', code='$code' WHERE id='$id'";
    $exe = mysqli_query($con, $query);
    $arr = [];
    if ($exe) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
        $arr["error"] = mysqli_error($con);
    }
    header('Content-Type: application/json');
    print(json_encode($arr));
} else {
    echo json_encode(["success" => "false", "error" => "Datos incompletos"]);
}
?>