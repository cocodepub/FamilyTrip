<?
header("Content-type: image/jpeg");

// $author = $_GET["blog_user_id"];
$id = $_GET["id"];

$db = mysqli_connect("localhost","root","1234","travel_db");
if($db){
    $SQL = "SELECT photo FROM blog WHERE id = '$id';";
    $result = mysqli_query($db, $SQL);
    $row = mysqli_fetch_row($result);
    $pic_blob = $row[0];
    echo $pic_blob;
    mysqli_close($db);
}else{
  echo "download fail";
}