import Foundation

struct Conditions: Codable, Hashable {
    let cashWithdrawalChargeOwnCurrency: String
    let cashWithdrawalChargeForeignCurrency: String
    let paymentForeignCurrencyCharge: String
    let annualFee: String
    let payoffInfo: String

    init(
        cashWithdrawalChargeOwnCurrency: String,
        cashWithdrawalChargeForeignCurrency: String,
        paymentForeignCurrencyCharge: String,
        annualFee: String,
        payoffInfo: String
    ) {
        self.cashWithdrawalChargeOwnCurrency = cashWithdrawalChargeOwnCurrency
        self.cashWithdrawalChargeForeignCurrency = cashWithdrawalChargeForeignCurrency
        self.paymentForeignCurrencyCharge = paymentForeignCurrencyCharge
        self.annualFee = annualFee
        self.payoffInfo = payoffInfo
    }

    init() {
        self.cashWithdrawalChargeOwnCurrency = ""
        self.cashWithdrawalChargeForeignCurrency = ""
        self.paymentForeignCurrencyCharge = ""
        self.annualFee = ""
        self.payoffInfo = ""
    }
}
