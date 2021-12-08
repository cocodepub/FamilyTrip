//
//  SearchTableViewCell.swift
//  Travel_home_search
//
//  Created by AllyHuang on 2021/11/12.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var labSearchLoactionName: UILabel!
    @IBOutlet weak var labSearchCounty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
