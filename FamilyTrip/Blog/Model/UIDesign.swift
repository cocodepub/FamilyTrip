//
//  UIDesgin.swift
//  blog
//
//  Created by eve on 2021/11/14.
//

import Foundation
import UIKit

class UI{
    
    static func circular(ui: UIView, radius: Int){
        ui.frame.size.height = CGFloat(radius)
        ui.frame.size.width = ui.frame.size.height
        ui.layer.cornerRadius =  ui.bounds.width * 0.5
        ui.clipsToBounds = true
    }
    
    static func roundedRect(ui: UIView, radius: Int){
        ui.layer.cornerRadius = CGFloat(radius)
    }
    
    
}
