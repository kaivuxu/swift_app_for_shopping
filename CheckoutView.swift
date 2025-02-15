import SwiftUI

struct CheckoutView: View {
    let detectedItems: [DetectedItem] // Now using real detected items

    var totalBill: Double {
        Double(detectedItems.count) * 5.0 // Example price per item, modify as needed
    }

    var body: some View {
        VStack {
            Text("Checkout")
                .font(.largeTitle)
                .bold()

            List(detectedItems) { item in
                HStack {
                    Text(item.className)
                        .font(.headline)
                    Spacer()
                    Text("$5.00") // Example price per item
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Text("Total: $\(String(format: "%.2f", totalBill))")
                .font(.title2)
                .bold()
                .padding()

            NavigationLink(destination: PaymentView(totalAmount: totalBill)) {
                Text("Proceed to Payment")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
