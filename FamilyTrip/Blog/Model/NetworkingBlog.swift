//
//  Networking.swift
//  FamilyTrip
//
//  Created by eve on 2021/11/25.
//

import Foundation
import UIKit

class NetworkingBlog: NSObject {
    
    static func post(blog: BlogPost){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd_hh:mm:ss"
        let timeNow = formatter.string(from: Date())
        
        //http
        let boundary: String = UUID().uuidString
        var request = URLRequest(url: URL(string: "http://localhost/php/famTrip/blogPost.php")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        postString(post: "uid" , value: blog.uid)
        postString(post: "userID" , value: blog.userID)
        postString(post: "timestamp" , value: blog.timestamp)
        postString(post: "title" , value: blog.title)
        postString(post: "content" , value: blog.content)
        postString(post: "date" , value: blog.date)
        postString(post: "likeCount" , value: String(blog.like_count))
        postString(post: "city" , value: blog.city)
        postString(post: "dist" , value: blog.dist)
        postBLOB(file: "photo", fileName: timeNow, value: blog.photo, compress: 0.1)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data
        //the end
        
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task: URLSessionDataTask = session.dataTask(with: request) {(data,response,error) in
            if error == nil{
                if let safeData = data {
                    let result = String(data: safeData, encoding: String.Encoding.utf8)!
                    print(result)
                }
            }else{
                print(error!)
            }
        }
        task.resume()
        
        //MARK: - PHP $POST
        //$POST
        func postString(post: String, value: String){
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(post)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)".data(using: .utf8)!)
        }
        //$_FILES
        func postBLOB(file: String, fileName: String, value: UIImage, compress: CGFloat ){
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(file)\"; filename=\"\(fileName).jpeg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(value.jpegData(compressionQuality: compress)!)
        }
        
    }
    var blogTb = BlogTable()

    func get(author: String){
        let serverUrl:URL = URL(string: "http://localhost/php/famTrip/blogGet.php?blog_user_id=" + author)!
        let request:URLRequest = URLRequest(url: serverUrl)
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error == nil{
                if let safeData = data{
//                    let result:String = String(data: safeData, encoding: String.Encoding.utf8)!
//                    print(result)
                    //MARK: - Parse XML
                    let parser: XMLParser = XMLParser(data: safeData)
                    parser.delegate = self
                    parser.parse()
                }
            }
        }
        task.resume()
    
    }

    
}
extension NetworkingBlog: XMLParserDelegate{
    
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        switch elementName{
        case "id":
            
            getSinglePhoto(id: attributeDict["value"]!)
            blogTb.c_id.append(Int(attributeDict["value"]!)!)
        case "date":
            let e = attributeDict["value"]!
            blogTb.c_date.append(e)
        case "title":
            blogTb.c_title.append(attributeDict["value"]!)
        case "content":
            blogTb.c_content.append(attributeDict["value"]!)
        case "like_count":
            blogTb.c_like_count.append(Int(attributeDict["value"]!)!)
        case "city":
            blogTb.c_city.append(attributeDict["value"]!)
        case "dist":
            blogTb.c_dist.append(attributeDict["value"]!)
        default:
            break
        }
    }
    
    internal func getSinglePhoto(id: String) {

            let serverUrl:URL = URL(string: "http://localhost/php/famTrip/blogGetPic.php?id=\(id)")!
            let request:URLRequest = URLRequest(url: serverUrl)
            let session: URLSession = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error == nil{
                    if let safeData = data{
                        self.blogTb.c_photo.append(UIImage(data: safeData)!)
                    }
                }
            }
            task.resume()
    }
    
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print(blogTb.c_date)
        print("parser done!")
    }
    
}
