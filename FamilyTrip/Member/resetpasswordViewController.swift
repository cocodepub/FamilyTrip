import UIKit
import Firebase
import FirebaseAuth

class resetpasswordViewController: UIViewController
{

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func submitAction(_ sender: Any) {
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "警告", message: "請輸入電子信箱", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "成功", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "錯誤!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "成功!"
                    message = "請至您的信箱收信，重新設定密碼！"
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    

}
