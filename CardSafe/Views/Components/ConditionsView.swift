//
//  ConditionsView.swift
//  CardSafe
//
//  Created by Nico Petersen on 10.06.25.
//

import SwiftUI

struct ConditionsView: View {
    @State var cashWithdrawalChargeOwnCurrency: String = ""
    @State var cashWithdrawalChargeForeignCurrency: String = ""
    @State var paymentForeignCurrencyCharge: String = ""
    @State var annualFee: String = ""
    @State var payoffInfo: String = ""

    init(conditions: Conditions) {
        self._cashWithdrawalChargeOwnCurrency = State(initialValue: conditions.cashWithdrawalChargeOwnCurrency)
        self._cashWithdrawalChargeForeignCurrency = State(initialValue: conditions.cashWithdrawalChargeForeignCurrency)
        self._paymentForeignCurrencyCharge = State(initialValue: conditions.paymentForeignCurrencyCharge)
        self._annualFee = State(initialValue: conditions.annualFee)
        self._payoffInfo = State(initialValue: conditions.payoffInfo)
    }
    var body: some View {
        Section {
            LabeledTextField(
                label: "Gebühr für Bargeldabhebung in eigener Währung",
                text: $cashWithdrawalChargeOwnCurrency
            )
            LabeledTextField(
                label: "Gebühr für Bargeldabhebung in Fremdwährung",
                text: $cashWithdrawalChargeForeignCurrency
            )
            LabeledTextField(
                label: "Gebühr für Zahlungen in Fremdwährung",
                text: $paymentForeignCurrencyCharge
            )
            LabeledTextField(
                label: "Jahresgebühr",
                text: $annualFee
            )
            LabeledTextField(
                label: "Rückzahlungsinformationen",
                text: $payoffInfo
            )
        } header: {
            Text("Konditionen")
        }
    }
}

#Preview {
    ConditionsView(conditions: .init())
}
