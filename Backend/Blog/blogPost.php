<?
// error_reporting(0);//don't not show any errors
$msg = "upload_fail";

    $uid = $_POST["uid"];
    $userID = $_POST["userID"];
    $timestamp = $_POST["timestamp"];
    $title = $_POST["title"];
    $content = $_POST["content"];
    $date = $_POST["date"];
    $likeCount = $_POST["likeCount"];
    $city = $_POST["city"];
    $dist = $_POST["dist"];
    $photo = $_FILES["photo"]["name"];//<input type="file" name="uploadfile" value="請選檔案" />
    echo "size ==>" .$_FILES["photo"]["size"]."<br>";
    $tempname = $_FILES["photo"]["tmp_name"]; //this var will be deleted after saved
    $imgData = addslashes(file_get_contents($tempname));

    $db = mysqli_connect("localhost","root","1234","travel_db");

    if($db){
      echo "db connected \n";
      $SQL = "INSERT INTO blog(uid, user_id, timestamp,title,content,date,photo,like_count,city,dist) VALUES ('$uid','$userID','$timestamp','$title','$content','$date','$imgData','$likeCount','$city','$dist');";
      //" echo $SQL; " will  crash xcode
       //execute query
       $result = mysqli_query($db, $SQL);
       if($result == 1){
         $msg = "upload_ok";
       }
       mysqli_close($db);
  }else{
      // $fp = fopen("fail.jpg","rb");
      // fpassthru($fp);
      // fclose($fp);
    die("<img src='fail.jpg' />");
  }
  echo $msg;
?>