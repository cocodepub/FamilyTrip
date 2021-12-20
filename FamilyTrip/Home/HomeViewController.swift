//
//  ViewController.swift
//  Travel_home_search
//
//  Created by AllyHuang on 2021/11/10.


import UIKit

struct placeDetail:Codable
{
    var UID:String = ""
    var title:String = ""
    var content:String = ""
    var city:String = ""
    var dist:String = ""
    var addr1:String = ""
}


class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, DataFetchDelegate{
    
    
    @IBOutlet weak var btnMarquee: UIButton!
    @IBOutlet weak var txtKeyWord: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var keyword:String?
    var city:String?
    var myTextDelegator:MyTextFieldDelegate!
    var isKeywordSearch:Bool=false
    
    
    //** add by ally 2021/12/09
    //for news data
    var newData:DataFetch?
    var newTable = [placeDetail]()
    //** add by ally 2021/12/09
    
    //*** add by Ally 2021/12/9 ***
   
    
    
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
    
    
    //跑馬燈 target function
    @objc func gogo(_ timer:Timer){
        let position:CGPoint = btnMarquee.layer.position
        var new_position:CGPoint = CGPoint(x: Int(position.x) - 2, y: Int(position.y))
        
        //print(btnMarquee.frame.maxX)
        if (btnMarquee.frame.maxX == 0){
            new_position  = CGPoint(x: 680, y: 90)
        }
        
        btnMarquee.layer.position = new_position
        //print(new_position)
    }
    //*** End add by Ally 2021/12/9 ***
    
    
    //MARK:-- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //搜尋框設定
        txtKeyWord.backgroundColor = UIColor.clear
        txtKeyWord.textAlignment = NSTextAlignment.left
        txtKeyWord.borderStyle = .bezel
        
        myTextDelegator = MyTextFieldDelegate(self)
        txtKeyWord.delegate = myTextDelegator
        
        
        //** add by ally 2021/12/10
    
        //跑馬燈 Timer
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(gogo), userInfo: nil, repeats: true)
        
        newData = DataFetch()
        newData?.delegate = self
        newData?.get_DataBytime()
        tableView.reloadData()
        //** end add by ally 2021/12/10
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //print("Appear newTable=\(newTable.count)")
        if newTable.count == 0 {
            DispatchQueue.main.async
            {
                self.alertView(title: "抱歉~ \n無資料可分享!!", message: "資料建構中....")
            }
        }
    }
    
    
    //隱藏狀態列
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    //segue 傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSearchPage"
        {
            
            let searchTVC = segue.destination as! SearchTableViewController
            searchTVC.vc = self
        }
        else if segue.identifier == "goToNewDetail"
        {
           
            let detailVC = segue.destination as! Detail
            detailVC.VC = self
        }
    }
        
    
    //MARK:-- Delegate
    func itemDownloaded(placeDetail: [placeDetail]) {
        newTable = placeDetail
        
        //回主執行序
        DispatchQueue.main.async
        {
            //重新載入tableView
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: -- Target Action
    
    //按跑馬燈觸發
    @IBAction func goToWeb(_ sender: UIButton) {
        if let url = URL(string: "https://www.taiwan.net.tw") {
            UIApplication.shared.open(url)
        }
    }
    
    //由虛擬鍵盤的return鍵觸發的事件
    @IBAction func didEndOnExit(_ sender: UITextField) {
        //不需實作即可收起鍵盤
    }
  
    //文字輸入框開始編輯時觸發
    @IBAction func editingDidBegin(_ sender: UITextField) {
        sender.keyboardType = .default
        
    }
    
    @IBAction func goToSearchPage(_ sender: UIButton) {
        //print("sender.currentTitle = \(sender.currentTitle!)")
        
        //若按搜尋(放大鏡)按鈕
        if sender.currentTitle == nil {
            
            isKeywordSearch = true
            //抓 搜尋關鍵字
            keyword = txtKeyWord.text!
          
            if keyword!.count != 0 {
                //print("keyword = \(keyword!)")
                
                //導到下一頁(SearchTableViewController)
                performSegue(withIdentifier: "toSearchPage", sender: sender)
            }else{
                //print("No keyword can search !!")
                
                //alert message
                DispatchQueue.main.async { [self] in
                    var popup_controller:UIAlertController
                    popup_controller = UIAlertController(title: "Warning!!", message: "No keyword can search!\n Please Input search word!!", preferredStyle: UIAlertController.Style.alert)
                    
                    let button:UIAlertAction = UIAlertAction(
                        title: "OK!",
                        style: UIAlertAction.Style.default,
                        handler:
                           nil)
                    
                    popup_controller.addAction(button)
                    
                    self.present(popup_controller, animated:  true, completion: nil)
                    //txtKeyWord拿到焦點
                    //txtKeyWord.becomeFirstResponder()
                }
            }
        }
        else //按縣市圖片按鈕
        {
            isKeywordSearch = false

            city = sender.currentTitle!
          
            //導到下一頁(SearchTableViewController)
            performSegue(withIdentifier: "toSearchPage", sender: sender)
                       
        }
    }
    
    
    //** add by ally 2021/12/09
    //MARK:-- UITableViewDataSource protocol
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! NewTableViewCell
        
        //去資料庫抓圖片
        //step 1: prepare REQUEST
        let server_place:String="http://127.0.0.1/FamilyTrip/Home/get_lblob_byuid.php?uid=" + newTable[indexPath.row].UID
        
        //print("server_place=\(server_place)")
        let server_url:URL = URL(string:server_place)!
        let request:URLRequest=URLRequest(url: server_url)
        
        //step 2: create Session
        //跟手機的瀏灠器借session,so use .shared
        let session:URLSession=URLSession.shared
        
        //step 3: create the TASK that you want to do in the session
        var work:URLSessionDataTask
        
        work = session.dataTask(with: request, completionHandler: {
            (data,respose,error)
             in

            if error == nil
            {
                //轉回主要執行緒顯示照片
                DispatchQueue.main.async {
                    if let picData = data
                    {
                        cell.cellImage?.image = UIImage(data: picData)
                        //print("*** picData= \(picData)")
                    }else{
                        cell.cellImage?.image = UIImage(systemName: "sun.max")
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
        
        cell.cellTitle.text =  newTable[indexPath.row].title
        //cell.textLabel?.text = newTable[indexPath.row].title
        //cell.detailTextLabel?.text = newTable[indexPath.row].city
        
        return cell
    }
    //** end add by ally 2021/12/09
    
    
    
}

