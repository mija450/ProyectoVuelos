<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json');
include "../flutter_api/db.php";

$id = $_POST['id'];
$name = $_POST['name'];
$age = (int) $_POST['age'];

$stmt = $db->prepare("UPDATE student SET name = ?, age = ? WHERE id =
?");
$result = $stmt->execute([$name, $age, $id]);

echo json_encode([
'success' => $result
]);