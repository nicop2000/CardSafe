import Foundation

enum CardType: Codable, Hashable {

    case credit, debit, prepaid, gift, other

    var display: String {
        switch self {
        case .credit:
            return "Credit Card"
        case .debit:
            return "Debit Card"
        case .prepaid:
            return "Prepaid Card"
        case .gift:
            return "Gift Card"
        case .other:
            return "Other Card"
        }
    }
}
