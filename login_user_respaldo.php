<?php
include 'dbconnection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $con = dbconnection();

    $query = "SELECT * FROM users WHERE email = '$email' AND password = '$password'";
    $result = mysqli_query($con, $query);

    if (mysqli_num_rows($result) > 0) {
        $user = mysqli_fetch_assoc($result);
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

    mysqli_close($con);
}
?>
