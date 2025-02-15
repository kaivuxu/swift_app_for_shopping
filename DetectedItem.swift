import Foundation

struct RoboflowResponse: Codable {
    let predictions: [DetectedItem]
}

struct DetectedItem: Identifiable, Codable {
    let id = UUID()
    let className: String
    let confidence: Double

    enum CodingKeys: String, CodingKey {
        case className = "class"
        case confidence
    }
}
