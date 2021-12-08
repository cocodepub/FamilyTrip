
//  DataFetch.swift
//
//  Created by AllyHuang on 2021/11/23
//

import UIKit

protocol DataFetchDelegate{
    func itemDownloaded(placeDetail:[placeDetail])
}

class DataFetch: NSObject {
    
    var delegate:DataFetchDelegate?
    
    //單筆景點資料
    var structRow = placeDetail()
    //存放從資料庫查詢到的景點資料
    var arrTable = [placeDetail]()
    var webDomain:String = "http://127.0.0.1/FamilyTrip/"

    
    //MARK: -- 自訂method
    
    //用輸入的關鍵字搜尋(找 tilte,content,縣市)
    func get_DataBykeyword(keyword ky:String){
        //step 1: prepare REQUEST
        //指定提供XML網路服務的網址
        let strURL = webDomain + "get_blogdata_json_bykeyword.php?keyword=" + ky
        //print(strURL)
        getJson(strURL: strURL)
    }
    

    //去資料庫抓資料，用city搜尋
    func get_DataByCity(City city:String){
        if city != ""{
            //step 1: prepare REQUEST
            //指定提供XML網路服務的網址
            let strURL = webDomain + "get_blogdata_json_bycity.php?city=" + city
            getJson(strURL: strURL)
            
        }
        else
        {
            print("NO city selected!")
        }
    }
    
    
    func getJson(strURL:String){
        //先清空離線資料集
        self.arrTable.removeAll()
        
        //有中文字要轉碼
        let server_place:String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        //將web service的網址形成URL實體
        let url = URL(string: server_place)!
        
        //step 2: create Session
        //跟手機的瀏灠器借session,so use .shared
        let session:URLSession=URLSession.shared
        
        //step 3: create the TASK that you want to do in the session
        var dataTask:URLSessionDataTask
        
        //由網路串流物件來"準備"資料傳輸任務
        dataTask = session.dataTask(with: url, completionHandler: {
            jsonData, response, error
                in
            //當web service存取成功時
            if error == nil
            {
                //初始化 json資料的解碼器
                let decoder = JSONDecoder()
                print("jsonData = \(jsonData!)")
                
                //讓json解碼器開始解碼json資料到placeDetail結構的陣列中
                if let jData = jsonData,let placeResults = try? decoder.decode([placeDetail].self, from: jData)
                {
                    //print("解碼後的json資料=\(placeResults)")
                    //離線資料集取得解碼過後的資料
                    self.arrTable = placeResults
                    //回主執行緒，回傳array
                    DispatchQueue.main.async {
                        self.delegate?.itemDownloaded(placeDetail: self.arrTable)
                    }
                }else{
                    //print("Json資料解析不出來!!")
                }
            }
            else
            {
                //print("沒有拿到Json資料！！！")
            }
            
        })
        //執行資料傳輸任務
        dataTask.resume()
    }
    
}
