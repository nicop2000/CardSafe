//
//  CardListItem.swift
//  CardSafe
//
//  Created by Nico Petersen on 10.06.25.
//


import SwiftUI

struct CardListItem: View {
    let card: Card
    var body: some View {
        HStack(spacing: 16) {
            card.cardBranding.logo(card.customBranding)
            VStack(alignment: .leading, spacing: 4) {
                Text(bankAndName)
                    .font(.headline)
                Text(card.cardHolderName)
                    .font(.footnote)
                Text("**** \(card.paymentInfo.cardNumber.suffix(4))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 8) {
                    Text(card.cardType.display)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Group {
                        Text("Gültig bis: \(String(format: "%02d", card.paymentInfo.expirationDate.month))/")
                        + Text(String(format: "%02d", card.paymentInfo.expirationDate.year))
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
    }

    var bankAndName: String {
        if card.name.isEmpty {
            return card.bank
        } else if card.bank.isEmpty {
            return card.name
        } else {
            return "\(card.name) – \(card.bank)"
        }
    }
}

#Preview {
    VStack {
        Group {
            CardListItem(card: Card.amex)
            CardListItem(card: Card.visa)
            CardListItem(card: Card.mastercard)
            CardListItem(card: Card.discover)
            CardListItem(card: Card.other)
        }
        .padding()
    }
}
