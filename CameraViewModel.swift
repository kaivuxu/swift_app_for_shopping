import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private let queue = DispatchQueue(label: "cameraQueue")
    var onCapture: (([DetectedItem]) -> Void)?

    override init() {
        super.init()
        setupCamera()
    }

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { self.startSession() }
            }
        default:
            break
        }
    }

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
        } catch {
            print("Error setting up camera: \(error)")
        }
    }

    private func startSession() {
        queue.async {
            self.session.startRunning()
        }
    }

    func capturePhoto(completion: @escaping ([DetectedItem]) -> Void) {
        print("📷 capturePhoto() called!") // Debugging Step 3
        self.onCapture = completion
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }



    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("❌ Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        print("📸 Photo captured successfully!") // Debugging Step 4
        
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            print("📤 Sending image to Roboflow...") // Debugging Step 5
            sendToRoboflow(image: image)
        } else {
            print("❌ Failed to get image data")
        }
    }


    private func sendToRoboflow(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Error: Could not convert image to JPEG data")
            return
        }

        print("🌐 Sending request to Roboflow API...") // Debugging Step

        let url = URL(string: "https://detect.roboflow.com/shop_stock_dataset/1?api_key=ScOeSJPGmXhq78pAXSKj")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // **Fix: Use multipart/form-data**
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let fileName = "image.jpg"

        // **Multipart Form Data Formatting**
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ No data received from Roboflow")
                return
            }

            print("✅ Response received from Roboflow!") // Debugging Step

            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Full API Response: \(jsonString)") // Debugging Step
                }
                
                let detectionResponse = try JSONDecoder().decode(RoboflowResponse.self, from: data)
                DispatchQueue.main.async {
                    self.onCapture?(detectionResponse.predictions)
                }
            } catch {
                print("❌ JSON Parsing Error: \(error)")
            }
        }
        task.resume()
    }


}
