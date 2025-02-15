import SwiftUI
import Razorpay

class RazorpayDelegate: NSObject, RazorpayPaymentCompletionProtocol {
    func onPaymentSuccess(_ payment_id: String) {
        print("✅ Payment Successful: \(payment_id)")
    }

    func onPaymentError(_ code: Int32, description str: String) {
        print("❌ Payment Failed: \(str)")
    }
}

struct PaymentView: View {
    let totalAmount: Double
    @State private var razorpay: RazorpayCheckout?


    var body: some View {
        VStack {
            Text("Payment")
                .font(.largeTitle)
                .bold()

            Text("Total Amount: $\(String(format: "%.2f", totalAmount))")
                .font(.title2)
                .bold()
                .padding()

            Button(action: initiatePayment) {
                Text("Pay Now")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            razorpay = RazorpayCheckout.initWithKey("rzp_test_rlZ55kiLMZVyZT", andDelegate: RazorpayDelegate())

        }
    }

    func initiatePayment() {
        let options: [String: Any] = [
            "amount": Int(totalAmount * 100), // Convert to paisa
            "currency": "USD",
            "description": "Shopping Cart Payment",
            "prefill": [
                "email": "customer@example.com",
                "contact": "9999999999"
            ]
        ]

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            razorpay?.open(options, displayController: rootVC)
        } else {
            print("❌ Error: Unable to get root view controller")
        }
    }


    
}
