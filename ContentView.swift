import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var cameraModel = CameraViewModel()
    @State private var detectedItems: [DetectedItem] = []

    var body: some View {
        VStack {
            CameraPreview(session: cameraModel.session)
                .frame(height: 400)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )

            Button(action: {
                print("📸 Detect Items button clicked!") // Debugging Step 1
                cameraModel.capturePhoto { items in
                    print("📥 Received detected items: \(items)") // Debugging Step 2
                    detectedItems = items
                }
            }) {
                Text("Detect Items")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()


            List(detectedItems) { item in
                HStack {
                    Text(item.className)
                    Spacer()
                    Text("\(String(format: "%.2f", item.confidence * 100))% confidence")
                        .bold()
                }
            }

            NavigationLink(destination: CheckoutView(detectedItems: detectedItems)) {
                Text("Go to Checkout")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .onAppear {
            cameraModel.checkPermissions()
        }
    }
}
