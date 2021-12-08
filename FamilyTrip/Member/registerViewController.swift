import UIKit
import Firebase
//import FirebaseFirestore

class registerViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    let db = Firestore.firestore()
    var uid = ""
    
    
    //MARK: - view cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    @IBAction func JoinUS(_ sender: UIButton) {
        // Validate the field, 先對textField做判斷
        let error = validateTextField()
        if error != nil {
            popAlert(title: "錯誤通知", message: error!, alertTitle: "OK") { (action) in
//                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.repasswordTextField.text = ""
//                self.userNameTextField.text = ""
            }
        } else {
          
            if let email = emailTextField.text,
               let password = passwordTextField.text,
               let userName = userNameTextField.text {
                // 建立user
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        self.popAlert(title: "錯誤通知", message: error.localizedDescription, alertTitle: "OK") { (action) in
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.repasswordTextField.text = ""
                            self.userNameTextField.text = ""
                        }
                    } else {
                        self.db.collection(Constant.FireStore.users).addDocument(data: [Constant.FireStore.userName: userName, Constant.FireStore.uid: authResult!.user.uid]) { (error) in
                            if let error = error {
                                print(error)
                            } else {
                                if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                                    currentUser.displayName = userName
                                    currentUser.commitChanges { (error) in
                                        if let error = error {
                                            print(error)
                                        } else {
                                            if let user = Auth.auth().currentUser {
                                                self.uid = user.uid
                                                self.performSegue(withIdentifier: Constant.Segue.signupSegue, sender: self)
                                                //=================================================
                                                let server_place:String = "http://localhost/familytrip/register.php"
                                                let server_url:URL = URL(string: server_place)!
                                                var request:URLRequest = URLRequest(url: server_url)
                                                
                                                
                                                let boundary = UUID().uuidString
                                                
                                                // set up request....
                                                // we have three parts: account, password, and picture
                                                request.httpMethod = "POST"
                                                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                                                var data = Data()
                                                // account part
                                                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                                                data.append("Content-Disposition: form-data; name=\"account\"\r\n\r\n".data(using: .utf8)!)
                                                data.append("\(email)".data(using: .utf8)!)
                                                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                                                // password part
                                                data.append("Content-Disposition: form-data; name=\"password\"\r\n\r\n".data(using: .utf8)!)
                                                data.append("\(password)".data(using: .utf8)!)
                                                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                                                // username part
                                                data.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n".data(using: .utf8)!)
                                                data.append("\(userName)".data(using: .utf8)!)
                                                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                                                data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
                                                
                                                request.httpBody = data
                                                // step2: create Session
                                                //let session:URLSession = URLSession.shared
                                                let config:URLSessionConfiguration = URLSessionConfiguration.default
                                                let session = URLSession(configuration: config)
                                                
                                                
                                                // step3: create the TASK that you want to do in the session
                                                var work:URLSessionDataTask
                                                work = session.dataTask(
                                                    with: request,
                                                    completionHandler:
                                                        {
                                                            
                                                            (data,response,error)
                                                            in
                                                            print("I finish request to server")
                                                            let real_data:String = String(data: data!, encoding: String.Encoding.utf8)!
                                                            print(real_data)
                                                        }
                                                )
                                                // step4: executive the TASK
                                                work.resume()
                                                //=================================================
                                                print("註冊成功")
                                                print(currentUser.displayName!)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    /*
     Check all textFields and validate that the data is correct,
     if everything is correct, this method returns nil,
     otherwise, it will return error message
     */
    func validateTextField() -> String? {
        // Check all textFields are filled in, 檢查所有的textField是否都有輸入
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            repasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "尚有欄位未填寫"
        }
        // Check wether repassword is same as password, 檢查重新輸入密碼是否與密碼一致
        if repasswordTextField.text != passwordTextField.text {
            return "密碼不一致，請重新輸入"
        }
        return nil
    }
    
    func transitionToMainPage() {
        let memberViewController = storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.mainPage) as? memberViewController
        view.window?.rootViewController = memberViewController
    }
    
    func popAlert(title: String, message: String, alertTitle: String, action: ((UIAlertAction) -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: alertTitle, style: .cancel, handler: action)
        controller.addAction(alert)
        present(controller, animated: true, completion: nil)
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
