//
//  ViewController.swift
//  Travel_home_search
//
//  Created by AllyHuang on 2021/11/10.
//

import UIKit

class HomeViewController: UIViewController{
 
    @IBOutlet weak var txtKeyWord: UITextField!
    
    var keyword:String?
    var city:String?
    var myTextDelegator:MyTextFieldDelegate!
    var isKeywordSearch:Bool=false
    
    //MARK: -- Target Action
    //由虛擬鍵盤的return鍵觸發的事件
    @IBAction func didEndOnExit(_ sender: UITextField) {
        //不需實作即可收起鍵盤
    }
  
    //文字輸入框開始編輯時觸發
    @IBAction func editingDidBegin(_ sender: UITextField) {
        sender.keyboardType = .default
        
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //搜尋框設定
        txtKeyWord.backgroundColor = UIColor.clear
        txtKeyWord.textAlignment = NSTextAlignment.left
        txtKeyWord.borderStyle = .bezel
        
        myTextDelegator = MyTextFieldDelegate(self)
        txtKeyWord.delegate = myTextDelegator
       
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
                    txtKeyWord.becomeFirstResponder()
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
    
   
    
}

