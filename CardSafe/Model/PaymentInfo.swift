import Foundation

struct PaymentInfo: Codable, Hashable {
    let cardNumber: String
    let expirationDate: Expiration
    let cvv: String

    func isValidCardNumber() -> Bool {
        let sanitized = cardNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        guard !sanitized.isEmpty, sanitized.allSatisfy(\.isNumber) else {
            return false
        }
        var sum = 0
        let reversedDigits = sanitized.reversed().map { Int(String($0))! }
        for (index, digit) in reversedDigits.enumerated() {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += (doubled > 9) ? (doubled - 9) : doubled
            } else {
                sum += digit
            }
        }

        return sum % 10 == 0
    }

    init(cardNumber: String, expirationDate: Expiration, cvv: String) {
        self.cardNumber = cardNumber
        self.expirationDate = expirationDate
        self.cvv = cvv
    }
    init() {
        self.cardNumber = ""
        self.expirationDate = Expiration(
            month: Calendar.current.component(.month, from: .now),
            year: Calendar.current.component(.year, from: .now)
        )
        self.cvv = ""
    }
}
