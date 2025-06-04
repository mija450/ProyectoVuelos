<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include("dbconnection.php");
$con = dbconnection();
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
if(isset($_POST["id"])) {
    $id = $_POST["id"];
} else {
    echo json_encode(["success" => "false", "error" => "Falta el ID"]);
    exit();
}
$query = "DELETE FROM reservations WHERE id='$id'";
$exe = mysqli_query($con, $query);
$arr = [];
if ($exe) {
    $arr["success"] = "true";
} else {
    $arr["success"] = "false";
    $arr["error"] = mysqli_error($con);
}
echo json_encode($arr);
?>