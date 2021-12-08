import UIKit
import Firebase
import FirebaseFirestore

class MainPageViewController: UIViewController
{
    
    @IBOutlet weak var welcomeLabel: UILabel!

    let db = Firestore.firestore()
    var uid = ""
    var userName = ""
    var isUserLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let user = Auth.auth().currentUser {
        //            uid = user.uid
        //            getUserInfo(uid: uid)
        //        }
        loadUser()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.isUserLoggedIn = true
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
                        navigationController?.popToRootViewController(animated: true)
            var rootVC = self.presentingViewController
            while let parent = rootVC?.presentingViewController {
                rootVC = parent
            }
            rootVC?.dismiss(animated: true, completion: nil)
            print("登出成功!")
        } catch let signOutError as NSError {
            print ("登出錯誤: %@", signOutError)
        }
    }
    
    
    func loadUser() {
        if let user = Auth.auth().currentUser {
            print("user: \(user)")
            uid = user.uid
            userName = user.displayName!
            DispatchQueue.main.async {
                self.welcomeLabel.text = "Welcome, \(self.userName)"
            }
        }
//        if let userInfo = Auth.auth().currentUser?.providerData {
//
//        }
    }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    
    // MARK: - Table view data source
    

   





}




