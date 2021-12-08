//
//  BlogVC.swift
//  FamilyTrip
//
//  Created by eve on 2021/11/27.
//

import UIKit

class BlogVC: UIViewController {

    var blog: BlogPost = BlogPost()
    
    @IBOutlet weak var locLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var articleDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTV.isEditable = false
        dateLb.text = blog.date
        articleDate.text = blog.date
        titleLb.text = blog.title
        contentTV.text = blog.content
        photoIV.image = blog.photo
        locLb.text = "\(blog.city) . \(blog.dist)"
    
    }
    
}
