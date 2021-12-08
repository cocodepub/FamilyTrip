import UIKit
import FirebaseAuth
//import FacebookLogin
//import GoogleSignIn
import FirebaseFirestore

class memberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Reference firestore object
    let db = Firestore.firestore()
//    let userData = db.collection(Constant.FireStore.users).document(uid)
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let error = validateTextField()
        if error != nil {
            popAlert(title: "錯誤通知", message: error!, alertTitle: "OK") { (action) in
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        } else {
            if let email = emailTextField.text,
               let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    // remove [weak self] & guard let strongSelf = self else { return }
                    if let error = error {
                        self.popAlert(title: "錯誤通知", message: error.localizedDescription, alertTitle: "OK") { (action) in
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                        }
                        print(error.localizedDescription)
                    } else {
                        if let user = Auth.auth().currentUser {
                            self.uid = user.uid
                            self.performSegue(withIdentifier: Constant.Segue.loginSegue, sender: self)

                            print("登入成功")
                            print(self.uid)
                        }
                    }
                }
            }
        }
    }
    /*
     1. 確保所有textField都有輸入值
     */
    func validateTextField() -> String? {
        // 檢查所有的textField是否都有輸入
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "尚有欄位未填寫"
        }
        return nil
    }
    
    
    func popAlert(title: String, message: String, alertTitle: String, action: ((UIAlertAction) -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: alertTitle, style: .cancel, handler: action)
        controller.addAction(alert)
        present(controller, animated: true, completion: nil)
    }
    
    func getUserInfo(uid: String) {
        db.collection(Constant.FireStore.users).document(uid).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("讀取錯誤, \(error!)")
                return
            }
            guard let data = document.data() else {
                print("檔案空白")
                return
            }
            print("Current data: \(data)")
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


