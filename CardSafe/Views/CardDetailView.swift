import SwiftUI

struct CardDetailView: View {
    let card: Card
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(card.name)
                        .font(.headline)
                    Text(card.cardHolderName)
                        .font(.headline)
                    Text(card.cardType.display)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(card.cardBranding.display)
                    .font(.title3)
                    .bold()
            }

            // Card Number + Expiration
            VStack(alignment: .leading, spacing: 4) {
                Text("**** \(card.paymentInfo.cardNumber.suffix(4))")
                    .font(.system(.title3, design: .monospaced))
                Text("Ablaufdatum: \(String(format: "%02d", card.paymentInfo.expirationDate.month))/\(card.paymentInfo.expirationDate.year)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Divider()

            // Conditions
            VStack(alignment: .leading, spacing: 4) {
                Text("Konditionen")
                    .font(.subheadline)
                    .bold()
                Text("Gebühr für Bargeldabhebung in eigener Währung: \(card.conditions.cashWithdrawalChargeOwnCurrency)")
                Text("Gebühr für Bargeldabhebung in Fremdwährung: \(card.conditions.cashWithdrawalChargeForeignCurrency)")
                Text("Gebühr für Zahlungen in Fremdwährung: \(card.conditions.paymentForeignCurrencyCharge)")
                Text("Jahresgebühr: \(card.conditions.annualFee)")
                Text("Rückzahlungsinformationen: \(card.conditions.payoffInfo)")
            }
            .font(.footnote)

            // Additionals
            Divider()
            VStack(alignment: .leading, spacing: 4) {
                Text("Zusatzinformationen")
                    .font(.subheadline)
                    .bold()
                Text("PIN: \(card.additionals.pin)")
                Text("Notiz: \(card.additionals.freeText)")
            }
            .font(.footnote)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .shadow(radius: 4)
    }
}

#Preview {
    CardDetailView(
        card: Card.mastercard
    )
}
