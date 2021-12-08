
//  MyTextFieldDelegate.swift
//  Created by AllyHuang on 2021/11/22


import UIKit


//一定要 inherit UITextFieldDelegate
class MyTextFieldDelegate: NSObject,UITextFieldDelegate {
    
    var working_controller:HomeViewController!

    
    init(_ controller:HomeViewController){
        working_controller = controller
    }
    
    
    //按Enter觸發
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("textFieldShouldReturn....")
        
        if let you_input:String = textField.text{
            if (you_input.count < 1){
                print("Your don't inpurt any character !!")
                
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
                    
                    self.working_controller!.present(popup_controller, animated:  true, completion: nil)
                    textField.becomeFirstResponder()
                }
                
            }
            else
            {
                textField.resignFirstResponder()
                //input_password 拿到焦點(focus)
                working_controller.txtKeyWord.becomeFirstResponder()
            }
        
        }
        return true
    }
    
    
    // 可能進入結束編輯狀態
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //print("textFieldShouldEndEditing...")
        
        if let you_input:String = textField.text{
            if (you_input.count < 1){
                print("Your must input something to search !!")
                
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

                    self.working_controller!.present(popup_controller, animated:  true, completion: nil)
                    
                    textField.becomeFirstResponder()
                }
            }
        }
    
        return true
    }
    
    
    //UITextField 輸入字元即會觸發的 Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("textField....")
//        //{第幾位，長度}
//        print(range)
//        //顯示 keyin 字元
//        print(string)
        
        
        //若刪除字元時~
        guard string.count != 0 else{
            return true
        }
        
        guard let t=textField.text,t.count != 0 else{
            return true
        }
        
        var character_ok:Bool=true
                
        
        if string >= " " && string <= "/"{
            character_ok = false
        }else if string >= ";" && string <= "@"{
            character_ok = false
        }else if string >= "[" && string <= "`"{
            character_ok = false
        }else if string >= "{" && string <= "?"{
            character_ok = false
        }else{   //enter
            character_ok = true
        }
        
        if character_ok == false {
            print("Character not Legal!!")
            
            //彈一個訊息視窗
            var popup_controller:UIAlertController
            popup_controller = UIAlertController(title: "Warning", message: "Character not ALLOWED!!", preferredStyle: UIAlertController.Style.alert)
            
            
            let button:UIAlertAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler:nil)
            
            popup_controller.addAction(button)
            working_controller!.present(popup_controller, animated: true, completion: nil)
        }
     
        return character_ok
        
    }
}



