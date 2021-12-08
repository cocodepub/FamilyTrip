//
//  TaiwanData.swift
//  blog
//
//  Created by eve on 2021/11/19.
//

import Foundation

enum City: CaseIterable{
    case 臺北市, 新北市, 基隆市, 桃園市, 新竹縣, 新竹市, 苗栗縣, 臺中市, 南投縣, 彰化縣, 雲林縣, 嘉義縣, 嘉義市, 臺南市 , 高雄市, 屏東縣, 宜蘭縣, 花蓮縣, 臺東縣, 澎湖縣, 金門縣, 連江縣
}

class TaiwanJson{
    static func fetchDist(cityName: String) ->Array<String>{
        var district: Array<String> = []
    
        let url = Bundle.main.url(forResource: "Taiwan", withExtension: "json")
        
        do{
            let data = try Data(contentsOf: url!)
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Array<Any>]
            district = jsonObj[cityName] as! [String]

        }catch{
            print(error.localizedDescription)
        }
        return district
    }
}
