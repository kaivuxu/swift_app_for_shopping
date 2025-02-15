
# 🛒 Smart_app_for_shopping  

## 📌 Overview  
The **Smart Shopping Cart** app is an iOS application built with **Swift (SwiftUI + UIKit), Firebase, and Roboflow's YOLOv5 object detection**. It allows users to scan products using their phone's camera, detect items in real-time, and add them to a virtual cart for checkout.

---

## 🚀 Features  
✅ **Real-time object detection** using Roboflow's YOLOv5 model  
✅ **Firebase Authentication** for user login and management  
✅ **Dynamic cart system** that updates detected items and calculates total price  
✅ **Smooth camera integration** using `AVCaptureSession`  
✅ **Planned Razorpay integration** for seamless checkout payments  

---

## 🏗 Tech Stack  
- **Swift (SwiftUI + UIKit)** – Frontend UI & logic  
- **AVFoundation** – Camera functionality  
- **Firebase (Firestore & Auth)** – Database & authentication  
- **Roboflow API** – YOLOv5 object detection  
- **Razorpay** (Coming Soon) – Payment gateway  

---

## 📸 Screenshots  
![IMG_6282](https://github.com/user-attachments/assets/c4c14eb5-281f-47bc-a931-c1c8a14a8949)

 ![IMG_6298](https://github.com/user-attachments/assets/af9cd0e0-9b83-4898-bd1b-202a8c1853ea)
 ![IMG_6286](https://github.com/user-attachments/assets/059d7d88-4505-4401-90b7-9ff0704a67a0)
 ![IMG_6287](https://github.com/user-attachments/assets/31679245-164a-40cd-9bb3-db8dbba1d87a)




---

## 🔧 Setup & Installation  

### 1️⃣ **Clone the Repository**  
```sh
git clone https://github.com/YOUR_GITHUB_USERNAME/smart_app_for_shopping.git

2️⃣ Install Dependencies
Make sure you have Xcode 15+ installed.
Install CocoaPods dependencies (if required):
pod install
3️⃣ Set Up Firebase
Create a Firebase project at Firebase Console.
Enable Authentication (Email/Google Sign-In) and Firestore Database.
Download the GoogleService-Info.plist and place it in your Xcode project.
4️⃣ Set Up Roboflow API
Get your API key from Roboflow.
Replace the placeholder key in CameraViewModel.swift:
let url = URL(string: "https://detect.roboflow.com/YOUR_DATASET_NAME/1?api_key=YOUR_API_KEY")!
🔥 Contributing

We welcome contributions! To contribute:

Fork the repo
Create a new branch
Make your changes and commit
Submit a Pull Request
🛡 License

This project is MIT Licensed. See the LICENSE file for details.

📬 Contact

📧 Email: kaivalyakulkarni69@gmail.com

