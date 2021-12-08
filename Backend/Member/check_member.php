<?php

// step1: connect to database
$link = mysqli_connect("127.0.0.1", "root", "1234", "student_data");

// step2: do things
// check if connection ok
if ($link) {
    // connection ok
    $account = $_GET["account"];
    $password = $_GET["password"];
    $SQL = "select number from members where account='" . $account . "' and password='" . $password . "';";
    $result = mysqli_query($link, $SQL);
    $x = mysqli_num_rows($result);
    if ($x == 1) {
        echo "YES";
    } else {
        echo "NO";
    }

} else {
    // connection fail
    echo "FAIL";
}
// step3: close
mysqli_close($link);