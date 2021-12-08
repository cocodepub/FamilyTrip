//
//  PostCell.swift
//  FamilyTrip
//
//  Created by eve on 2021/11/25.
//

import UIKit

class BlogCell: UITableViewCell {

 
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowOffset = .zero
        bgView.layer.cornerRadius = 5
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
}
