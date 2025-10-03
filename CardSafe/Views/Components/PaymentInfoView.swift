//
//  PaymentInfoView.swift
//  CardSafe
//
//  Created by Nico Petersen on 10.06.25.
//

import SwiftUI

struct PaymentInfoView: View {
    let isDisabled: Bool
    @State var cardNumber: String = ""
    @State var expirationDate: String = ""
    @State var cvv: String = ""
    let onCardNumberChange: (String) -> Void

    init(paymentInfo: PaymentInfo = PaymentInfo(), isDisabled: Bool = false, onCardNumberChange: @escaping (String) -> Void = { _ in }) {
        self._cardNumber = State(initialValue: paymentInfo.cardNumber)
        self._expirationDate = State(initialValue: paymentInfo.expirationDate.asString())
        self._cvv = State(initialValue: paymentInfo.cvv)
        self.isDisabled = isDisabled
        self.onCardNumberChange = onCardNumberChange
    }
    var body: some View {
        Section {
            cardNumberView
            expirationDateView
            cvvView
        } header: {
            Text("Zahlungsinformationen")
        }
    }

    var cardNumberView: some View {
        LabeledTextField(label: "1234 5678 9012 3456", text: $cardNumber)
            .keyboardType(.numberPad)
            .onChange(of: cardNumber) { _, newValue in
                formatCardNumber(newValue)
                onCardNumberChange(cardNumber)
            }
            .disabled(isDisabled)
    }

    var expirationDateView: some View {
        LabeledTextField(label: "MM/YYYY", text: $expirationDate)
            .keyboardType(.numberPad)
            .textContentType(.none)
            .onChange(of: expirationDate) { _, newValue in
                formatExpirationDate(newValue)
            }
            .disabled(isDisabled)
    }

    private func formatCardNumber(_ input: String) {
        let digits = input.filter { $0.isWholeNumber }
        let groups = stride(from: 0, to: min(digits.count, 16), by: 4).map {
            Array(digits)[$0 ..< min($0 + 4, digits.count)]
        }
        cardNumber = groups.map { String($0) }.joined(separator: " ")
    }

    private func formatExpirationDate(_ input: String) {
        // Remove all non-digits
        var digits = input.filter { $0.isNumber }

        // Enforce MMYYYY format (6 digits max)
        if digits.count > 6 {
            digits = String(digits.prefix(6))
        }

        // Insert slash after 2 digits
        if digits.count >= 3 {
            let month = String(digits.prefix(2))
            let year = String(digits.dropFirst(2))
            expirationDate = "\(month)/\(year)"
        } else {
            expirationDate = digits
        }

        // Validate month
        if expirationDate.count >= 2 {
            let monthStr = String(expirationDate.prefix(2))
            if let month = Int(monthStr), !(1...12).contains(month) {
                // Invalid month — trim or reset
                expirationDate = ""
            }
        }
    }

    var cvvView: some View {
        LabeledTextField(
            label: "CVV",
            text: $cvv,
            isSecure: true,
            withToggle: true,
            isDisabled: isDisabled)
        .keyboardType(.numberPad)
        .onChange(of: cvv) { _, newValue in
            cvv = String(newValue.prefix(4).filter { $0.isWholeNumber })
        }
    }
}

#Preview {
    PaymentInfoView()
}
