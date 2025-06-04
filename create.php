<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json');
include "../flutter_api/db.php";

$name = $_POST['name'];
$age = (int) $_POST['age'];

$stmt = $db->prepare("INSERT INTO student (name, age) VALUES (?, ?)");
$result = $stmt->execute([$name, $age]);

echo json_encode([
'success' => $result
]);