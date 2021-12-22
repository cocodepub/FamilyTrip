<?php

//step 1 :connect to database
$link = mysqli_connect("127.0.0.1", "root", "1234", "travel_db");
// $uid = $_GET["uid"];
$id = $_GET["id"];
//step 2:do things
//check if connection ok
if ($link) {
    //connection ok
    $SQL = "SELECT photo FROM blog where id = '$id'";
    $result = mysqli_query($link, $SQL);

    //echo $SQL;
    //echo "<br>";

    $x = mysqli_num_rows($result);
    if ($x == 1) {
        //echo "YES";
        $row = mysqli_fetch_row($result);
        //header("Content-type: image/jpeg");

        echo $row[0];
    } else {
        echo "NO";
    }
} else {
    // connection fail
    echo "FAIL";
}
// step3: close
mysqli_close($link);