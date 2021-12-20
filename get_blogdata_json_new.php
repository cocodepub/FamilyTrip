<?php
//show all the error message
//error_reporting(E_ALL);
$db = mysqli_connect("127.0.0.1", "ally", "1qaz@wsx", "travel_db");

//自訂解碼Unicode的方法：傳入JSon格式，將其中的Unicode資料解碼回正常的中文字
function decodeUnicode($str)
{
    $func = function ($matches) {
        return mb_convert_encoding(pack("H*", $matches[1]), "UTF-8", "UCS-2BE");
    };
    return preg_replace_callback('/\\\\u([0-9a-f]{4})/i', $func, $str);
}

if ($db) {
    $sql = "SELECT UID,title,content,city,dist,addr1 FROM blog order by UID,timestamp LIMIT 30";
    // echo $sql;
    // echo "<br>";
    $result = mysqli_query($db, $sql);
    if ($result) {
        while ($row_array = mysqli_fetch_assoc($result)) {
            //將編碼過後的目前資料行(陣列型態)，存入新的資料集陣列
            $rows[] = $row_array;
        }
        //encode the array to JSON and output the results
        echo decodeUnicode(json_encode($rows));
    } else {
        echo "No data!!";
    }
} else {
    echo "DB connection fail!!";
}
mysqli_close($db);