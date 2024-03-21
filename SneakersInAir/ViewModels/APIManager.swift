//
//  APIManager.swift
//  SneakersInAir
//
//  Created by Salvo on 28/02/24.
//

import Foundation
import UIKit
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
    
    func loadPhoto() -> UIImage? {
        let fileURL = getImagePath()
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func uploadImageToImgur(image: UIImage) async throws{
        let parameters = [
            [
                "key": "image",
                "type": "file"
            ]] as [[String: Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
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
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = JSON(data)
            await MainActor.run{
                self.imgurLink = json["data"]["link"].string
                self.deleteHash = json["data"]["deletehash"].string
            }
            print("imgurLink: \(self.imgurLink ?? "null")")
            print("deleteHash: \(self.deleteHash ?? "null")")
        }catch{
            print("error 1 upload imgur")
        }
        
    }
    
    func deleteImageFromImgur(deleteHash: String) async throws{
        guard let url = URL(string: "https://api.imgur.com/3/image/\(deleteHash)")
        else {
            print ("error url")
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.setValue("Client-ID 7bc8b6980a0a59c", forHTTPHeaderField: "Authorization")
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = JSON(data)
            print("upload imgur state: \(json["success"])")
        }catch{
            print("error 2 delete imgur")
        }
        
    }
    
    func fetchDataFromServer(imageUrl: String) async throws{
        guard let url = URL(string: "https://sneakerinairapi-419f7e5625dd.herokuapp.com/api/snksJSON?imageUrl=\(imageUrl)")
        else {
            print ("error url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do{
            let(data, _) = try await URLSession.shared.data(for: request)
            let json = JSON(data)
            await MainActor.run{
                self.shoeName = json["shoeName"].string ?? "Shoe not found, please try again!"
                self.shoeImageLink = URL(string: json["thumbnail"].string ?? "https://i.imgur.com/UzNS5sB.png")
                self.finalJson = json
            }
            print("shoeName from json: \(String(describing: json["shoeName"].string))")
        }catch{
            print("error 3 fetch data from server")
        }

    }
    
    
}


