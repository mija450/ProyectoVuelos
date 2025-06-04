<?php
include 'dbconnection.php';

$con = dbconnection();
$query = "SELECT * FROM flights";
$result = mysqli_query($con, $query);

$flights = [];
while ($row = mysqli_fetch_assoc($result)) {
    $flights[] = $row;
}

echo json_encode($flights);

mysqli_close($con);
?>
