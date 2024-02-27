//
//  VisionAPIViewModel.swift
//  SneakersInAir
//
//  Created by Salvo on 27/02/24.
//

import Foundation

class VisionAPIViewModel: ObservableObject{
    
    @Published var answer: String?

    func getShoeName(url: URL){
        let apiKey = "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"

        let imagePath = url.path()

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
                        ["type": "text", "text": "Start from the shoe in the photo, get the name and the variant of the shoe and answer me with a response formatted this way: 'name;variant'. If there is any error, send this 'error;describe the error'"],
                        ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]]
                    ]
                ]
            ],
            "max_tokens": 2000
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
                    let decoder = JSONDecoder()
                    print(data)
                    let jsonData = try decoder.decode(Response.self, from: data)
                    print(jsonData)
                    self.answer = jsonData.choices[0].message.content
                    print("----------")
                    print(self.answer)
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
