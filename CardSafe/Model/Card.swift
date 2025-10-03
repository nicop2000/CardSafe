import Foundation

struct Card: Codable, Identifiable, Hashable, Comparable {
    static func < (lhs: Card, rhs: Card) -> Bool {
        // Priorität: Name (nicht leer > leer), dann Bank, dann Branding
        if lhs.name.isEmpty != rhs.name.isEmpty {
            return rhs.name.isEmpty // lhs wins if it’s non-empty
        }

        if lhs.name.isEmpty && rhs.name.isEmpty {
            if lhs.bank.isEmpty != rhs.bank.isEmpty {
                return rhs.bank.isEmpty // lhs wins if it’s non-empty
            }
            if lhs.bank != rhs.bank {
                return lhs.bank < rhs.bank
            }
            return lhs.cardBranding.display < rhs.cardBranding.display
        }

        return lhs.name < rhs.name
    }

    let id: String
    let name: String
    let cardHolderName: String
    let bank: String
    let paymentInfo: PaymentInfo
    let cardType: CardType
    let cardBranding: CardBranding
    let customBranding: String?
    let conditions: Conditions
    let additionals: Additionals

    init(
        id: String,
        name: String,
        cardHolderName: String,
        bank: String,
        paymentInfo: PaymentInfo,
        cardType: CardType,
        cardBranding: CardBranding,
        customBranding: String? = nil,
        conditions: Conditions,
        additionals: Additionals
    ) {
        self.id = id
        self.name = name
        self.cardHolderName = cardHolderName
        self.bank = bank
        self.paymentInfo = paymentInfo
        self.cardType = cardType
        self.cardBranding = cardBranding
        self.customBranding = customBranding
        self.conditions = conditions
        self.additionals = additionals
    }

    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.cardHolderName = ""
        self.bank = ""
        self.paymentInfo = PaymentInfo()
        self.cardType = .other
        self.cardBranding = CardBranding.amex
        self.conditions = Conditions()
        self.additionals = Additionals()
        self.customBranding = nil
    }
}

extension Card {
    enum CodingKeys: String, CodingKey {
        case id, name, cardHolderName, bank, paymentInfo, cardType, cardBranding, customBranding, conditions, additionals
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(cardHolderName, forKey: .cardHolderName)
        try container.encode(bank, forKey: .bank)
        try container.encode(paymentInfo, forKey: .paymentInfo)
        try container.encode(cardType, forKey: .cardType)
        try container.encode(cardBranding, forKey: .cardBranding)
        try container.encode(conditions, forKey: .conditions)
        try container.encode(additionals, forKey: .additionals)
        try container.encodeIfPresent(customBranding, forKey: .customBranding)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        cardHolderName = try container.decode(String.self, forKey: .cardHolderName)
        bank = try container.decode(String.self, forKey: .bank)
        paymentInfo = try container.decode(PaymentInfo.self, forKey: .paymentInfo)
        cardType = try container.decode(CardType.self, forKey: .cardType)
        cardBranding = try container.decode(CardBranding.self, forKey: .cardBranding)
        conditions = try container.decode(Conditions.self, forKey: .conditions)
        additionals = try container.decode(Additionals.self, forKey: .additionals)
        customBranding = try container.decodeIfPresent(String.self, forKey: .customBranding)
    }

}
