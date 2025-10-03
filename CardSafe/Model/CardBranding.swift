import Foundation
import SwiftUI

enum CardBranding: Codable, Hashable {
    case visa, mastercard, amex, discover, other

    var display: String {
        switch self {
            case .visa:
                return "Visa"
            case .mastercard:
                return "MasterCard"
            case .amex:
                return "American Express"
            case .discover:
                return "Discover"
            case .other:
                return "Other"
        }
    }

    static func from(number: String) -> Self {
        let sanitized = number.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        if sanitized.hasPrefix("4") {
            return .visa
        } else if sanitized.range(of: "^(5[1-5]|2[2-7])", options: .regularExpression) != nil {
            return .mastercard
        } else if sanitized.range(of: "^3[47]", options: .regularExpression) != nil {
            return .amex
        } else if sanitized.range(of: "^(6011|65|64[4-9]|622(12[6-9]|1[3-9][0-9]|[2-8][0-9]{2}|9[0-1][0-9]|92[0-5]))", options: .regularExpression) != nil {
            return .discover
        }
        return .other
    }

    func logo(_ otherBrand: String? = nil) -> some View {
        let imageView = { (name: String) in
            AnyView(
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
            )
        }
        var otherBrandPrefix: String {
            if let otherBrand, !otherBrand.isEmpty {
                return String(otherBrand.prefix(3)).uppercased()
            } else {
                return "?"
            }
        }
        switch self {
            case .visa:
                return imageView("visa")
            case .mastercard:
                return imageView("mastercard")
            case .amex:
                return imageView("amex")
            case .discover:
                return imageView("discover")
            case .other:
                return AnyView(
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(otherBrandPrefix)
                                .font(.headline)
                                .foregroundColor(.blue)
                        )
                )
        }
    }

}
