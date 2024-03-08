//
//  APIManager.swift
//  SneakersInAir
//
//  Created by Salvo on 28/02/24.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class APIManager: ObservableObject{
    
    @Published var imgurLink: String?
    @Published var deleteHash: String?
    @Published var shoeName: String?
    @Published var shoeImageLink: URL?
    @Published var finalJson: JSON?
    
    func getImagePath() -> URL{
        var URL: URL = URL(fileURLWithPath: "")
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            URL = Foundation.URL(fileURLWithPath: dirPath).appendingPathComponent("fotina.jpeg")
        }
        return URL
    }
    
    func uploadImageToImgur(image: UIImage){
        let parameters = [
            [
                "key": "image",
                "type": "file"
            ]] as [[String: Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        var error: Error? = nil
        for param in parameters {
            if param["disabled"] != nil { continue }
            let paramName = param["key"]!
            body += Data("--\(boundary)\r\n".utf8)
            body += Data("Content-Disposition:form-data; name=\"\(paramName)\"".utf8)
            if param["contentType"] != nil {
                body += Data("\r\nContent-Type: \(param["contentType"] as! String)".utf8)
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
                let paramValue = param["value"] as! String
                body += Data("\r\n\r\n\(paramValue)\r\n".utf8)
            } else {
                let fileURL = getImagePath()
                if let fileContent = try? Data(contentsOf: fileURL) {
                    body += Data("; filename=\"fotina.jpeg\"\r\n".utf8)
                    body += Data("Content-Type: \"content-type header\"\r\n".utf8)
                    body += Data("\r\n".utf8)
                    body += fileContent
                    body += Data("\r\n".utf8)
                }
            }
        }
        body += Data("--\(boundary)--\r\n".utf8);
        let postData = body
        
        
        var request = URLRequest(url: URL(string: "https://api.imgur.com/3/upload")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer bb1df6e74988b364a501cf5514890aa1417b039d", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data
            else {
                print(String(describing: error))
                return
            }
            let json = JSON(data)
            self.imgurLink = json["data"]["link"].string
            self.deleteHash = json["data"]["deletehash"].string
            print(self.imgurLink)
            print(self.deleteHash)
            
        }
        
        task.resume()
        
    }
    
    func deleteImageFromImgur(deleteHash: String) {
        guard let url = URL(string: "https://api.imgur.com/3/image/\(deleteHash)")
        else {
            print ("error url")
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.setValue("Client-ID 7bc8b6980a0a59c", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data
            else {
                print(String(describing: error))
                return
            }
            let json = JSON(data)
            print(json["success"])
        }
        task.resume()
    }
    
    func fetchDataFromServer(imageUrl: String) {
        let url = URL(string: "https://sneakerinairapi-419f7e5625dd.herokuapp.com/api/textFormatter?imageUrl=\(imageUrl)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("error: \(String(describing: error))")
            let json = JSON(data)
            let shoeName = json["name"].string
            print("shoename: \(shoeName)")
            self.finalDataFromServer(shoeName: shoeName ?? "Not Found")
        }
        task.resume()
    }
    
    func finalDataFromServer(shoeName: String){
        var urlComponents = URLComponents(string: "https://sneakerinairapi-419f7e5625dd.herokuapp.com")
        urlComponents?.path = "/api/snksJSON"
        urlComponents?.queryItems = [
            URLQueryItem(
                name: "snksName",
                value: shoeName
            )
        ]
        
        let url2 = urlComponents?.url
        print("url2: " + url2!.absoluteString)
        var request2 = URLRequest(url: url2!)
        request2.httpMethod = "GET"
        let task2 = URLSession.shared.dataTask(with: request2) { data2, response2, error2 in
            print("error2: \(String(describing: error2))")
            let json2 = JSON(data2)
            print("json2: \(json2["shoeName"].string)")
            self.shoeName = json2["shoeName"].string ?? "Shoe not found, please try again!"
            self.shoeImageLink = URL(string: json2["thumbnail"].string ?? "https://i.imgur.com/UzNS5sB.png")
            self.finalJson = json2
        }
        task2.resume()
    }
    
    
}


