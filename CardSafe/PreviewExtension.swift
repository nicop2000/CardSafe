extension Card {
    static let amex = Card(
        id: "AmexCardID",
        name: "Main Card",
        cardHolderName: "Nico Petersen",
        bank: "American Express Bank",
        paymentInfo: .init(
            cardNumber: "3714496353984311",
            expirationDate: .init(month: 12, year: 2024),
            cvv: "1234"
        ),
        cardType: .debit,
        cardBranding: .amex,
        conditions: .init(
            cashWithdrawalChargeOwnCurrency: "1%",
            cashWithdrawalChargeForeignCurrency: "2%",
            paymentForeignCurrencyCharge: "3%",
            annualFee: "10€",
            payoffInfo: "100 % per month"
        ),
        additionals: .init(
            pin: "1111",
            freeText: "Amex-specific note"
        )
    )

    static let visa = Card(
        id: "VisaCardID",
        name: "My Visa",
        cardHolderName: "Nico Petersen",
        bank: "Chase",
        paymentInfo: .init(
            cardNumber: "4344994347440035",
            expirationDate: .init(month: 11, year: 2025),
            cvv: "321"
        ),
        cardType: .credit,
        cardBranding: .visa,
        conditions: .init(
            cashWithdrawalChargeOwnCurrency: "1%",
            cashWithdrawalChargeForeignCurrency: "2%",
            paymentForeignCurrencyCharge: "3%",
            annualFee: "10€",
            payoffInfo: "100 % per month"
        ),
        additionals: .init(
            pin: "2222",
            freeText: "Visa-specific note"
        )
    )

    static let mastercard = Card(
        id: "MastercardCardID",
        name: "Master Master",
        cardHolderName: "Nico Petersen",
        bank: "CitiBank",
        paymentInfo: .init(
            cardNumber: "5555555555554444",
            expirationDate: .init(month: 10, year: 2026),
            cvv: "456"
        ),
        cardType: .gift,
        cardBranding: .mastercard,
        conditions: .init(
            cashWithdrawalChargeOwnCurrency: "1%",
            cashWithdrawalChargeForeignCurrency: "2%",
            paymentForeignCurrencyCharge: "3%",
            annualFee: "10€",
            payoffInfo: "100 % per month"
        ),
        additionals: .init(
            pin: "3333",
            freeText: "Mastercard-specific note"
        )
    )

    static let discover = Card(
        id: "DiscoverCardID",
        name: "I Discover",
        cardHolderName: "Nico Petersen",
        bank: "Discover Bank",
        paymentInfo: .init(
            cardNumber: "6011000990139424",
            expirationDate: .init(month: 9, year: 2027),
            cvv: "789"
        ),
        cardType: .prepaid,
        cardBranding: .discover,
        conditions: .init(
            cashWithdrawalChargeOwnCurrency: "1%",
            cashWithdrawalChargeForeignCurrency: "2%",
            paymentForeignCurrencyCharge: "3%",
            annualFee: "10€",
            payoffInfo: "100 % per month"
        ),
        additionals: .init(
            pin: "4444",
            freeText: "Discover-specific note"
        )
    )

    static let other = Card(
        id: "OtherCardID",
        name: "Some other",
        cardHolderName: "Nico Petersen",
        bank: "Some Credit Union",
        paymentInfo: .init(
            cardNumber: "1234567890123456",
            expirationDate: .init(month: 8, year: 2028),
            cvv: "987"
        ),
        cardType: .other,
        cardBranding: .other,
        conditions: .init(
            cashWithdrawalChargeOwnCurrency: "1%",
            cashWithdrawalChargeForeignCurrency: "2%",
            paymentForeignCurrencyCharge: "3%",
            annualFee: "10€",
            payoffInfo: "100 % per month"
        ),
        additionals: .init(
            pin: "5555",
            freeText: "Custom brand card"
        )
    )
}
