import Foundation
import UIKit
   
    class RoboflowService {
        private let apiKey = "" // Replace with your actual API Key
        private let modelEndpoint = "your roboflow model url, shop_stock_dataset is used for this project"

        func detectObjects(image: UIImage, completion: @escaping ([DetectedItem]?) -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                print("❌ Error: Could not convert image to JPEG data")
                completion(nil)
                return
            }

            let fileContent = imageData.base64EncodedString()
            let postData = fileContent.data(using: .utf8)

            var request = URLRequest(url: URL(string: modelEndpoint)!, timeoutInterval: Double.infinity)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type") // FIXED HEADER
            request.httpBody = postData

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("❌ Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                // Print Full API Response
                print("✅ Response received from Roboflow!")
                print("📄 Full API Response: \(String(data: data, encoding: .utf8) ?? "No data")")

                // Convert JSON response into DetectedItem array
                do {
                    let response = try JSONDecoder().decode(RoboflowResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(response.predictions)
                    }
                } catch {
                    print("❌ JSON Parsing Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }.resume()
        }
    }
