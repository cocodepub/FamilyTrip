import UIKit
import Firebase
import FirebaseFirestore


let db = Firestore.firestore()
var uid = ""
var account = ""
var isUserLoggedIn = false

struct Blog:Codable
{
    var id = ""
    var account = ""
    var photo = ""
    var title = ""
    var phone = ""
    var address = ""
}


class favoriteTableViewController: UITableViewController,XMLParserDelegate
{
    var structRow = Blog()
    
    //宣告學生陣列，存放從資料庫查詢到的資料（此陣列及離線資料集）
    var arrTable = [Blog]()
    
    //-------------------------- MySQL增加 --------------------------
    //記錄主要提供web service的address
    let webDomain = "http://192.168.0.101/familytrip/"
    //記錄目前處理中的網路服務
    var strURL = "" //ex:select_data.php
    //記錄目前處理中的網路物件
    var url:URL!
    //取得預設的網路串流物件
    var session = URLSession.shared
    //宣告網路資料傳輸任務型別（可同時適用於上傳下載）
    var dataTask:URLSessionDataTask!
    //記錄目前正在處理XML標籤名稱
    var tagName = ""
    //記錄目前正在處理XML標籤內容
    var tagContent = ""

    //---------------------------------------------------------------
    
    //MARK: - 自訂函式
    
    func loadUser() {
        
        if let user = Auth.auth().currentUser {
            uid = user.uid
            account = user.email!
            print("user: \(account)")
        }
//        else{
//
//            
//            let alertController = UIAlertController(title: "警告", message: "請先登入會員", preferredStyle: .alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            present(alertController, animated: true, completion: nil)
//            
//        }

    }
    
    //從網路服務讀取JSon資料
    func getDataFromJson()
    {
        strURL = "select_to_json.php?account=" + account
        url = URL(string: webDomain + strURL)
        //由網路串流物件來“準備”資料傳輸任務
        dataTask = session.dataTask(with: url, completionHandler: {
            jsonData, response, error
            in
            //當web service存取成功時
            if error == nil
            {
                //先清空離線資料集
                self.arrTable.removeAll()
                //初始化JSon資料的解碼器
                let decoder = JSONDecoder()
                //讓JSon解碼器開始解碼JSon資料到Student結構的陣列中
                if let jdata = jsonData,let blogResults = try? decoder.decode([Blog].self, from: jdata)
                {
//                    print("解碼後的JSon資料\(studentResults)！")
                    //離線資料集取得解碼過後的資料
                    self.arrTable = blogResults
                    //轉回主執行緒，重整表格資料
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                print("沒有拿到JSon資料！！！")
            }
        })
        dataTask.resume()
        
    }

    
    //MARK: - Target Action
    //導覽列的編輯按鈕
    @objc func buttonEditAction(_ sender:UIBarButtonItem)
    {
        print("編輯按鈕被按")
        if self.tableView.isEditing //如果表格在編輯狀態
        {
            //取消編輯狀態
            self.tableView.isEditing = false
            //更改按鈕文字
            self.navigationItem.leftBarButtonItem?.title = "編輯"
        }
        else    //如果表格不在編輯狀態
        {
            self.tableView.isEditing = true
            //更改按鈕文字
            self.navigationItem.leftBarButtonItem?.title = "取消"
        }
    }
    
    //由下拉更新元件呼叫的事件
    @objc func handleRefresh()
    {
        //step1.重新讀取實際資料庫資料，並填入離線資料庫（arrTable）
        getDataFromJson()
        
        //step2.執行表格更新資料（重新執行tableview datasourece三個事件）
        self.tableView.reloadData()
        
        //step3.停止下拉的動畫特效
        self.tableView.refreshControl?.endRefreshing()
    }
    
    
    
    //MARK - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadUser()
        getDataFromJson()
    
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(buttonEditAction(_:)))
        
        //準備下拉更新元件
        self.tableView.refreshControl = UIRefreshControl()
        //當下拉更新元件出現時（觸發valueChanged事件），綁定執行事件
        self.tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //提供下拉更新元件的提示文字
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            isUserLoggedIn = true
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTable.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! favoriteCell
        
        print("網址：\(webDomain + arrTable[indexPath.row].photo)")
        //準備取得大頭照的URL物件
        url = URL(string: webDomain + arrTable[indexPath.row].photo)
        //準備大頭照的資料傳輸任務
        if url != nil
        {
            dataTask = session.dataTask(with: url, completionHandler: {
                imgData, response, error
                in
                if error == nil
                {
                    //轉回主要執行緒顯示大頭照
                    DispatchQueue.main.async {
                        if let picData = imgData
                        {
                            cell.blogPicture.image = UIImage(data: picData)
                        }
                    }
                }
                else
                {
                    print("無法取得景點照片：\(error!.localizedDescription)")
                }
            })
            //執行取得大頭照的傳輸任務
            dataTask.resume()
        }
        
        cell.blogTitle.text = arrTable[indexPath.row].title
        cell.blogPhone.text = arrTable[indexPath.row].phone
        cell.blogAddr.text = arrTable[indexPath.row].address

        return cell
    }
    
    //MARK: - Table View Delegate
    //回傳儲存格高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }

    //<方法一>哪一個儲存格被點選
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("『\(arrTable[indexPath.row].title)』被點選")
    }


    //========================== 表格刪除相關作業（舊版）===========================
    //提交編輯狀態（通常只用於刪除，若需更換按鈕文字，需配合下一個事件：titleForDeleteConfirmationButtonForRowAt）
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
//        if editingStyle == .delete
//        {
            //step1.先刪除資料庫資料
            //----- to do ------
          

        
    
        
        
        
        
        
//            //step2.刪除陣列資料
//            arrTable.remove(at: indexPath.row)
//            //step3.刪除儲存格
//
//            tableView.deleteRows(at: [indexPath], with: .fade)

    }
    
    //更換刪除按鈕的文字
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "刪除此筆資料"
    }
    //============================================================================
    //========================== 表格刪除相關作業（7-9新版會取代舊版）===========================
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {

//        let db = Firestore.firestore()
//        if let userID = Auth.auth().currentUser?.email{}
            
            let delete = UIContextualAction(style: .normal, title: "刪除此筆收藏") { (action, view, bool) in
                print("『刪除』按鈕按下")
                let order = self.arrTable[indexPath.row]
                let url = URL(string: "http://192.168.0.101/familytrip/delete_json.php?account=\(order.account)&id=\(order.id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data,
                       let dic = try? JSONDecoder().decode([String: Int].self, from: data),
                       dic["deleted"] == 1 {
                        
                        DispatchQueue.main.async {
                            self.arrTable.remove(at: indexPath.row)
                            self.tableView.reloadData()
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                            
                        }
                    }
                }.resume()
                
                self.arrTable.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        
            delete.backgroundColor = .blue
            
            //左滑到底時不做任何動作
            let swipeAction = UISwipeActionsConfiguration(actions: [delete])
            swipeAction.performsFirstActionWithFullSwipe = false
            
            return swipeAction
            
        }
    //============================================================================



    //MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        print("開始標籤：\(elementName)")
        //記錄目前處理中的開始標籤
        tagName = elementName
    }
    //讀到標籤內容時
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("標籤內容：\(string)")
        //記錄目前處理中的標籤內容
        tagContent = string
    }
    //讀到結束標籤時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("結束標籤：\(elementName)")
        switch elementName
        {
        case "id":
            structRow.id = tagContent
        case "account":
            structRow.account = tagContent
        case "photo":
            structRow.photo = tagContent
        case "title":
            structRow.title = tagContent
        case "phone":
            structRow.phone = tagContent
        case "address":
            structRow.address = tagContent
        case "student": //單筆學生資料結束時
            //將資料加入陣列
            arrTable.append(structRow)
        default:
            break
        }
    }
    
    //解析完整份xml文件時
    func parserDidEndDocument(_ parser: XMLParser)
    {
        //轉回主執行緒更新表格資料
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
    }

}
