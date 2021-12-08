<?PHP
//指定網頁的中文格式
header("Content-type: text/html; charset=utf-8");
//連接資料庫
$user = "root"; //資料庫帳號
$password = "1234"; //資料庫密碼
$host = "127.0.0.1"; //資料庫IP
$db = "travel_db"; //資料庫名稱
$conn = mysqli_connect($host, $user, $password) or die("資料庫連線錯誤！");
//指定連線的資料庫
mysqli_select_db($conn, $db);
//指定資料庫使用的編碼
mysqli_query($conn, "SET NAMES utf8");
$account = $_GET["account"];
//存取資料表
//SELECT no, name, gender, picture, phone, address, email, class FROM student
$table = mysqli_query($conn, "SELECT id,account,photo,title,phone,address FROM favorite WHERE account = '" . $account . "'");

//宣告記錄xml資料的變數
$doc = new DOMDocument('1.0', 'utf-8');
//讓後續的輸出格式化
$doc->formatOutput = true;
//建立根節點
$xmlTable = $doc->appendChild($doc->createElement('xmlTable'));

while ($row_array = mysqli_fetch_row($table)) {
    //echo $row_array[0] . ',' . $row_array[1] . '<br>';
    //一筆資料的開頭
    $row = $doc->createElement('student');
    //------------依序欄位的節點--------------
    //第0欄:id
    $column = $row->appendChild($doc->createElement('id'));
    $column->appendChild($doc->createTextNode($row_array[0]));
    //第1欄:account
    $column = $row->appendChild($doc->createElement('account'));
    $column->appendChild($doc->createTextNode($row_array[1]));
    //第2欄:photo
    $column = $row->appendChild($doc->createElement('photo'));
    $column->appendChild($doc->createTextNode($row_array[2]));
    //第3欄:title
    $column = $row->appendChild($doc->createElement('title'));
    $column->appendChild($doc->createTextNode($row_array[3]));
    //第4欄:phone
    $column = $row->appendChild($doc->createElement('phone'));
    $column->appendChild($doc->createTextNode($row_array[4]));
    //第5欄:address
    $column = $row->appendChild($doc->createElement('address'));
    $column->appendChild($doc->createTextNode($row_array[5]));

    $xmlTable->appendChild($row);
}
//將$doc寫成xml格式的文件
$xmlStr = $doc->saveXML();
//關閉資料庫連結
mysqli_close($conn);
//顯示整份xml文件
echo $xmlStr;