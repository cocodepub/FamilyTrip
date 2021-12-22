//
//  Detail.swift
//  FamilyTrip
//
//  Created by AllyHuang on 2021/12/13.
//

import UIKit
import MapKit        //引入地圖框架

class Detail: UIViewController {
    
    @IBOutlet weak var imgViewDetail: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labAddr: UILabel!
    @IBOutlet weak var txtViewContent: UITextView!
    
    
    //MARK:-- instance properties
    
    //接收上一頁ViewController 的執行實體(從 prepare function 從過來)
    weak var VC:HomeViewController!
    //紀錄上一頁被點選的row
    private var currentRow:Int = 0
    //紀錄目前處理中的景點資料
    var currentData = placeDetail()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        //HomeViewController 哪個cell被點選
        currentRow = VC.tableView.indexPathForSelectedRow!.row
        
        //接收上一頁的陣列紀錄當筆資料
        currentData = VC.newTable[currentRow]
        
        
        //去資料庫抓圖片
        //step 1: prepare REQUEST
        let server_place:String="http://127.0.0.1/FamilyTrip/get_lblob_byuid.php?uid="+currentData.UID
        
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
                        self.imgViewDetail.image = UIImage(data: picData)
                    }else{
                        self.imgViewDetail.image = UIImage(named:"新竹市")
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
        
        
        labTitle.text = currentData.title
        if currentData.addr1 == ""{
            labAddr.text = currentData.city+currentData.dist
        }else{
            labAddr.text = currentData.addr1
        }
        
        txtViewContent.text = currentData.content
    }
    
    
    @IBAction func NaviToAddress(_ sender: UIButton) {
        //初始化地理資訊編碼器
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(labAddr.text!)
        {
            placemarks, error
             in
            //無錯誤，表示地址順利編碼成經緯度資訊
            if error == nil{
                //是否可以取得經緯度資訊
                if placemarks != nil {
                    //step 1.
                    //(第一層)取得地址對應的緯度資訊標示
                    let toPlaceMark = placemarks!.first!
                    //(第二層)將經緯度資訊的位置標示轉換成導航地圖上的目的地的大頭針
                    let toPin = MKPlacemark(placemark: toPlaceMark)
                    //(第三層)產生導航地圖上導航終點的大頭針
                    let destMapItem = MKMapItem(placemark: toPin)
                    
                    //setp 2. 設定導航為開車模式
                    let navOption = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    //setp 3. 使用(第三層)開啟導航地圖
                    destMapItem.openInMaps(launchOptions: navOption)
                }
            }else{
                print("地址解碼錯誤: \(error!.localizedDescription)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

