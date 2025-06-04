<?php

function dbconnection() {
    $con = mysqli_connect("localhost", "root", "", "flight_booking");
    return $con;
}

?>