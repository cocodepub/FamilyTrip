//
//  DataDriven.swift
//  FamilyTrip
//
//  Created by eve on 2021/11/22.
//

import Foundation
import UIKit


struct BlogPost{
    let uid: String = UUID().uuidString
    var userID: String = UUID().uuidString
    var timestamp: String = String(NSDate().timeIntervalSince1970)
    var title: String = ""
    var content: String = ""
    var date: String = String(NSDate().timeIntervalSince1970)
    var like_count: Int = 0
    var city: String = ""
    var dist: String = ""
    var photo: UIImage = UIImage(named: "noPhoto")!
    var username: String = ""
    

}

struct BlogTable{
    
    var c_id: [Int] = []
    var c_date: [String] = []
    var c_title: [String] = []
    var c_content: [String] = []
    var c_like_count: [Int] = []
    var c_city: [String] = []
    var c_dist: [String] = []
    var c_photo: [UIImage] = []
    var c_photoData: [String] = []
    var c_username: [String] = []
    
}
