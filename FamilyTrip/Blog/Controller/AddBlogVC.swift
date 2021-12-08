//
//  AddPostVC.swift
//  blog
//
//  Created by eve on 2021/11/14.
//

import UIKit

protocol DatePickerVCDelegate{
    func saveText(strText : String)
}
class AddBlogVC: UIViewController {
    
    var city: Array<String> = []
    var dist: Array<String> = []
    var seletedImage: UIImage?{
        didSet{
            print("ok,i got the image!, postImg here you go , load it!")
            blog.photo = seletedImage!
        }
    }
    
    //DB
    var blog: BlogPost = BlogPost()
    
    var currentObjectBottomYPoistion:CGFloat = 0

    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var bgV: UIView!
    @IBOutlet var toolbar: UIToolbar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoIV.image = seletedImage
        
        //fetch Taiwan Data
        for c in City.allCases{
            city.append("\(c)")
        }
        //Delegate
        contentTV.delegate = self
        titleTF.delegate = self
        
        //UI
        contentTV.text = "story write here..."
        contentTV.textColor = UIColor.lightGray
        
        bgV.layer.shadowColor = UIColor.black.cgColor
        bgV.layer.shadowOpacity = 0.3
        bgV.layer.shadowOffset = .zero
        
        
        //toolbar
        for ui in view.subviews{
            if ui is UITextView {
                (ui as! UITextView).inputAccessoryView = toolbar
            }
            if ui is UITextField {
                (ui as! UITextField).inputAccessoryView = toolbar
            }
            
        }
        
        //MARK: - Keyboard Adjustment
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     

    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        //get height
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            print(keyboardHeight)
            let visiableHeight = self.view.bounds.height - keyboardHeight.height
            if currentObjectBottomYPoistion > visiableHeight
            {
                self.view.frame.origin.y -= currentObjectBottomYPoistion - visiableHeight
            }
        }
    }
    
    @objc func keyboardWillHide(){
        self.view.frame.origin.y = 0
    }
    
    //MARK: -Private func
    private func updateCurrentY(sender: UIView){
        currentObjectBottomYPoistion = sender.frame.origin.y + sender.frame.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone.current
        dateFormat.dateFormat = "YYYY-MM-dd HH:mm"
        
        //Nav title
        title = dateFormat.string(from: Date())
        dateLb.text = dateFormat.string(from: Date())
        
        UI.roundedRect(ui: photoIV, radius: 5)
        UI.roundedRect(ui: bgV, radius: 5)
    }
    
    
    //MARK: - widget action
    @IBAction func upLoadBtn(_ sender: UIButton) {
        NetworkingBlog.post(blog: blog)
        if let nav = self.navigationController {
             nav.popViewController(animated: true)
         } else {
             self.dismiss(animated: true, completion: nil)
         }
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        currentObjectBottomYPoistion = 0
        if contentTV.text == ""{
            contentTV.text = "story write here..."
            contentTV.textColor = UIColor.lightGray
        }
        self.view.endEditing(true)
    }
    

    
   
    
    
}
//MARK: - Text Field Delegate
extension AddBlogVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleTF.text != nil {
            //unfocus the textfield
            titleTF.endEditing(true)
            return true
        } else {
            titleTF.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let title = titleTF.text{
            blog.title = title
            self.view.endEditing(true)
        }
    }
    
    
}


//MARK: - Text View Delegate
extension AddBlogVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateCurrentY(sender: textView)
        print(textView.frame.height)
        if contentTV.textColor == UIColor.lightGray {
            textView.text = ""
            contentTV.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        currentObjectBottomYPoistion = 0
        if contentTV.text == ""{
            contentTV.text = "story write here..."
            contentTV.textColor = UIColor.lightGray
        }
        blog.content = contentTV.text
        self.view.endEditing(true)
    }
}

//MARK: - Popover Delegates
extension AddBlogVC : UIPopoverPresentationControllerDelegate & DatePickerVCDelegate{
    
    func saveText(strText: String) {
        title = strText
        dateLb.text = strText
        blog.date = strText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDatePicker"{
            let vc = segue.destination as! DatePickerVC
            vc.delegate = self //SavingPopoverDataDelegate
//            vc.strText = title!
        }
        
        let popoverCtrl = segue.destination.popoverPresentationController
        if sender is UIBarButtonItem {
            popoverCtrl?.barButtonItem = sender as? UIBarButtonItem
        }
        popoverCtrl?.delegate = self
        
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
}

//MARK: - Picker View
extension AddBlogVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if component == 0{
            return city.count
        }else if component == 1{
            return dist.count
        }
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if component == 0{
            dist = TaiwanJson.fetchDist(cityName: city[row])
            blog.city = city[row]
            print("city:\(city[row])")
            pickerView.reloadComponent(1)
        }else if component == 1{
            blog.dist = dist[row]
            print("dist:\(dist[row])")
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        if component == 0{
            dist = TaiwanJson.fetchDist(cityName: city[row])
            pickerView.reloadComponent(1)
            return fontSize(16,title: city[row])
            
        }else if component == 1{
            return fontSize(16,title: dist[row])
        }
         
        func fontSize(_ size: Int, title: String) ->UIView{
            var pickerLabel = view as? UILabel;
                if (pickerLabel == nil)
                {
                    pickerLabel = UILabel()
                    pickerLabel?.font = UIFont(name: "Montserrat", size: CGFloat(size))
                    pickerLabel?.textAlignment = NSTextAlignment.center
                }
            pickerLabel?.text = title
                return pickerLabel!
        }
        
        return fontSize(16,title: city[row])
    }
    
}
