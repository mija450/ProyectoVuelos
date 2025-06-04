<?php
    include("dbconnection.php");
    $con = dbconnection();

    if (isset($_POST["id"])) {
        $id = $_POST["id"];
    } else {
        echo json_encode(["success" => "false"]);
        return;
    }

    $query = "DELETE FROM reservations WHERE id = '$id'";
    $exe = mysqli_query($con, $query);
    $arr = [];

    if ($exe) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
    }

    echo json_encode($arr);
?>
