//
//  SearchTableViewController.swift
//  Travel_home_search
//
//  Created by AllyHuang on 2021/11/10.


import UIKit

class SearchTableViewController: UITableViewController,DataFetchDelegate {
    
    @IBOutlet weak var indicate: UIActivityIndicatorView!
    
    //接收上一頁的執行實體(從 prepare function 從過來)
    weak var vc:HomeViewController!
    
    //資料處理類別
    var myData:DataFetch?
    //存放從資料庫查詢到的景點資料
    var arrTable = [placeDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicate.isHidden = false

        DispatchQueue.main.async{
            //至資料庫抓取縣市景點資料
            self.myData = DataFetch()
            self.myData!.delegate = self
            
            //用縣市搜尋
            if !self.vc.isKeywordSearch{
                self.myData!.get_DataByCity(City: self.vc.city!)
            }
            else
            {//用關鍵字搜尋
                self.myData!.get_DataBykeyword(keyword: self.vc.keyword!)
            }
            //重新載入tableView
            self.tableView.reloadData()
        }
        
        indicate.isHidden = true
    }
    
    //*** add by Ally 2021/12/9 ***
    override func viewDidAppear(_ animated: Bool) {
        //print("Appear arrTable=\(arrTable.count)")
        if arrTable.count == 0 {
            DispatchQueue.main.async
            {
                self.alertView(title: "抱歉~ \n無資料可分享!!", message: "資料建構中....")
            }
        }
        
    }
    
    
    //MARK: -- 自訂method
    func alertView(title:String, message:String){
        var popup_controller:UIAlertController
        popup_controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        let button:UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler:nil
        )
        
        popup_controller.addAction(button)
        present(popup_controller, animated: true, completion: nil)
    }
    //*** End add by Ally 2021/12/9 ***
    
    
    //MARK: -- Delegate
    //DataFetchDelegate's protocol
    func itemDownloaded(placeDetail: [placeDetail]) {
        arrTable = placeDetail
        
        //回主執行序
        DispatchQueue.main.async
        {
            //重新載入tableView
            self.tableView.reloadData()
        }
        
    }
    
        
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrTable.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell

        //宣告儲存內容設定的物件
        
        //去資料庫抓圖片
        //step 1: prepare REQUEST
        let server_place:String="http://127.0.0.1/FamilyTrip/Home/get_lblob_byuid.php?uid=" + arrTable[indexPath.row].UID
        
        //print("server_place=\(server_place)")
        let server_url:URL = URL(string:server_place)!
        let request:URLRequest=URLRequest(url: server_url)
        
        //step 2: create Session
        //跟手機的瀏灠器借session,so use .shared
        let session:URLSession=URLSession.shared
        
        //step 3: create the TASK that you want to do in the session
        var work:URLSessionDataTask
        
        work=session.dataTask(with: request, completionHandler: {
            (data,respose,error)
             in

            if error == nil
            {
                //轉回主要執行緒顯示照片
                DispatchQueue.main.async {
                    if let picData = data
                    {
                        cell.imgSearch.image = UIImage(data: picData)
                        //print("*** picData= \(picData)")
                    }else{
                        cell.imgSearch.image = UIImage(named:"新竹市")
                    }
                }
            }
            else
            {
                print("無法取得照片：\(error!.localizedDescription)")
            }
        })
        //step 4:executive the TASK
        work.resume()
        
        
        cell.labSearchLoactionName.text = arrTable[indexPath.row].title
        cell.labSearchCounty.text = arrTable[indexPath.row].city
        
        return cell
    }
    
    
    //回傳 tableView cell 高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toSigleData"{
            let DetailVC = segue.destination as! DetailViewController
            //通知下一頁目前本頁的記憶體位置(執行實體)
            DetailVC.searchTVC = self
        }
    }
    
}
