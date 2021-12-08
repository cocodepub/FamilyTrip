//
//  DatePickerVC.swift
//  FamilyTrip
//
//  Created by eve on 2021/11/23.
//

import UIKit

class DatePickerVC: UIViewController {
    
    var delegate: DatePickerVCDelegate?
    //    var strText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print("title:\(strText!)")
    }
    
    @IBAction func dateOnChange(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-d"
        if (self.delegate) != nil{
            delegate?.saveText(strText: formatter.string(from: sender.date))
            self.dismiss(animated: true)
        }
    }
    
}
