//
//  VisionAPIViewModel.swift
//  SneakersInAir
//
//  Created by Salvo on 27/02/24.
//

import Foundation

class VisionAPIViewModel: ObservableObject{

    func getShoeName(){
        let apiKey = "YOUR_OPENAI_API_KEY"

        let imagePath = "path_to_your_image.jpg"

        guard let base64Image = encodeImage(imagePath: imagePath) else {
            fatalError("Failed to encode image")
        }

        let urlString = "https://api.openai.com/v1/chat/completions"

        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let json: [String: Any] = [
            "model": "gpt-4-vision-preview",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        ["type": "text", "text": "What’s in this image?"],
                        ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]]
                    ]
                ]
            ],
            "max_tokens": 300
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            fatalError("Failed to serialize JSON")
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print(json)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }

        task.resume()
    }

}

func encodeImage(imagePath: String) -> String? {
    do {
        let imageData = try Data(contentsOf: URL(fileURLWithPath: imagePath))
        return imageData.base64EncodedString()
    } catch {
        print("Error encoding image: \(error)")
        return nil
    }
}
