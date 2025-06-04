<?php
    include 'dbconnection.php';
    $con = dbconnection();

    $query = "SELECT `id`, `name`, `email` FROM `users`";
    $exe = mysqli_query($con, $query);

    $arr = [];
    while($row = mysqli_fetch_assoc($exe)) {
        $arr[] = $row;
    }
    print(json_encode($arr));
?>