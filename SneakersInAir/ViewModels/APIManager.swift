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
    @Published var json: Data?
    
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
        print(url)
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
        let urlString = "https://sneakerinairapi-419f7e5625dd.herokuapp.com/api/process-image?imageUrl=\(imageUrl)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Errore nella chiamata al server:", error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print("JSON da heroku ricevuto:", json ?? "Nessun dato")
                    } catch {
                        print("Errore nella decodifica JSON:", error.localizedDescription)
                    }
                }
            }
            task.resume()
        } else {
            print("URL non valido.")
        }
    }
    
}


