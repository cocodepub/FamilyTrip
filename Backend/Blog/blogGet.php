<?
error_reporting(E_WARNING | E_ERROR);
$xml = "";
$db = mysqli_connect("localhost","root","1234","travel_db");

if($db){

    $author = $_GET["blog_user_id"];
    $SQL = "SELECT * FROM blog WHERE user_id = '$author' ORDER BY date DESC;";
    $result = mysqli_query($db, $SQL);

        if($result){
        $xml = $xml . "<blog_data>\n\n";

        while($row = mysqli_fetch_row($result)){
                $xml = $xml ."<id value=\"$row[0]\">\n";
                // $xml = $xml ."<uid value=\"$row[1]\">\n";
                // $xml = $xml ."<user_id value=\"$row[2]\">\n";
                // $xml = $xml ."<timestamp value=\"$row[3]\">\n";
                $xml = $xml ."<title value=\"$row[4]\">\n";
                $xml = $xml ."<content value=\"$row[5]\">\n";
                $xml = $xml ."<date value=\"$row[6]\">\n";
                // $xml = $xml ."<photo  value=\"$row[7]\">\n";
                $xml = $xml ."<like_count value=\"$row[8]\">\n";
                $xml = $xml ."<city value=\"$row[9]\">\n";
                $xml = $xml ."<dist value=\"$row[10]\">\n";
            }
        $xml = $xml . "\n</blog_data>";
        }else{
        //error
            $xml = $xml . "<error>";
            $xml = $xml .     "download fail";
            $xml = $xml . "</error>";
        }

}else{
    //error
    $xml = $xml . "<error>";
    $xml = $xml .     "connect db fail";
    $xml = $xml . "</error>";
}
mysqli_close($db);
echo $xml;
