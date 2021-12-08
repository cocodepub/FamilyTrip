//
//  PostVC.swift
//  FamilyTrip
//
//  Created by eve on 2021/11/22.
//

import UIKit

class BlogListVC: UIViewController {
    
    var AppMainContext: UIApplication = UIApplication.shared
    var userBlogData: NetworkingBlog?
    var blog: BlogPost?
    
    let imgPC = UIImagePickerController()
    var postImg: UIImage = UIImage()
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate: AppDelegate = AppMainContext.delegate as! AppDelegate
        userBlogData = appDelegate.userBlogData
        
        imgPC.delegate = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.blogCell, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.rowHeight = 310
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addPostOnPress(_ sender: UIButton) {
        
        ///plist file: Privvacy - Photo Library Usage Description
        imgPC.sourceType = .photoLibrary
        //album
        imgPC.modalPresentationStyle = .currentContext
        show(imgPC, sender: self)
    }
    
    //MARK: - Connect to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoAddPost"{
            let vc = segue.destination as! AddBlogVC
            vc.seletedImage = postImg
        }
    }

}

//MARK: - Camera w/ Album
extension BlogListVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    //upload to UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        postImg = info[.originalImage] as! UIImage
//        print("Image is picked from album.")
        performSegue(withIdentifier: "gotoAddPost", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
}

extension BlogListVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userBlogData!.blogTb.c_date.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,for: indexPath) as!
        BlogCell
        let blogTable = userBlogData!.blogTb
        cell.dateLb.text = blogTable.c_date[indexPath.row]
        cell.titleLb.text = blogTable.c_title[indexPath.row]
        cell.locationLb.text = "[\(blogTable.c_city[indexPath.row]) . \(blogTable.c_dist[indexPath.row])]"
        cell.imgV.image = blogTable.c_photo[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let blogTable = userBlogData!.blogTb
        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: BlogVC = main.instantiateViewController(withIdentifier: K.blogVCstoryboard ) as!  BlogVC
        vc.blog.date = blogTable.c_date[indexPath.row]
        vc.blog.photo = blogTable.c_photo[indexPath.row]
        vc.blog.title = blogTable.c_title[indexPath.row]
        vc.blog.content = blogTable.c_content[indexPath.row]
        vc.blog.city = blogTable.c_city[indexPath.row]
        vc.blog.dist = blogTable.c_dist[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
}

