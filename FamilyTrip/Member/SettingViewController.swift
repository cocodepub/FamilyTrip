//
//  DetailViewController.swift
//  FamilyTrip
//
//  Created by 曾子 on 2021/11/24.
//

import UIKit

class SettingViewController: UIViewController,UINavigationControllerDelegate
{

    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    //接收上一頁的執行實體
    weak var myTableVC:MainPageViewController!
    //埋設紀錄目前被點選的資料行
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        print("上一頁的\(currentRow)被點選")
        
    }
}
