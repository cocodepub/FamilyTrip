<?php
error_reporting(0);

$msg = "register_fail";

$account = $_POST["account"];
$password = $_POST["password"];
$username = $_POST["username"];
// $filename = $_FILES["uploadfile"]["name"];
// $tempname = $_FILES["uploadfile"]["tmp_name"];

$db = mysqli_connect("localhost", "root", "1234", "travel_db");
// Get all the submitted data from the form
//$imgData = addslashes(file_get_contents($_FILES['uploadfile']['tmp_name']));
$sql = "INSERT INTO user (account, password, username) VALUES ('$account','$password','$username');";
// Execute query
$xxx = mysqli_query($db, $sql);
mysqli_close($db);
if ($xxx == 1) {
    $msg = "mysql_add_ok";
}
echo $msg;