<?php
function dbconnection() {
    $con = mysqli_connect("localhost", "root", "", "colegio");
    return $con;
}

?> 