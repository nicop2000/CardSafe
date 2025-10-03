import SwiftUI

struct CardEditView: View {
    @State var cardHolderName: String = ""
    @State var name: String = ""
    @State var bank: String = ""
    @State var pin: String = ""
    @State var freetext: String = ""
    @State var cardType: CardType = .credit
    @State var cardBranding: CardBranding = .visa
    @State var paymentInfo: PaymentInfo
    @State var conditions: Conditions
    @State var cardBrandingOther: String = ""
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var currentCard: Card
    let keychainAccessor = KeychainAccessor()
    @State private var isNew = false
    @State private var isEditing = false

    init(card: Card, isNew: Bool = false) {
        _cardHolderName = State(initialValue: card.cardHolderName)
        _name = State(initialValue: card.name)
        _bank = State(initialValue: card.bank)
        _pin = State(initialValue: card.additionals.pin)
        _freetext = State(initialValue: card.additionals.freeText)
        _cardType = State(initialValue: card.cardType)
        _cardBranding = State(initialValue: card.cardBranding)
        if card.cardBranding == .other {
            _cardBrandingOther = State(initialValue: card.customBranding ?? "")
        }
        self.currentCard = card
        self._isNew = State(initialValue: isNew)
        self._isEditing = State(initialValue: isNew)
        self._paymentInfo = State(initialValue: card.paymentInfo)
        self._conditions = State(initialValue: card.conditions)
    }

    var body: some View {
        List {
            Section {
                LabeledTextField(
                    label: "Karteninhaber:in",
                    text: $cardHolderName,
                    isDisabled: !isEditing)
                .textContentType(.name)
                .autocapitalization(.words)
                LabeledTextField(
                    label: "Name der Karte",
                    text: $name,
                    isDisabled: !isEditing)
                .textContentType(.name)
                .autocapitalization(.words)
                LabeledTextField(
                    label: "Bank",
                    text: $bank,
                    isDisabled: !isEditing)
                .textContentType(.organizationName)
                .autocapitalization(.words)
                Picker("Kartentyp", selection: $cardType) {
                    Text(CardType.credit.display).tag(CardType.credit)
                    Text(CardType.debit.display).tag(CardType.debit)
                    Text(CardType.prepaid.display).tag(CardType.prepaid)
                    Text(CardType.gift.display).tag(CardType.gift)
                    Text(CardType.other.display).tag(CardType.other)
                }
                .pickerStyle(.navigationLink)
                .disabled(!isEditing)
                HStack {
                    Picker("Zahlungsanbieter", selection: $cardBranding) {
                        Text(CardBranding.visa.display).tag(CardBranding.visa)
                        Text(CardBranding.mastercard.display).tag(CardBranding.mastercard)
                        Text(CardBranding.amex.display).tag(CardBranding.amex)
                        Text(CardBranding.discover.display).tag(CardBranding.discover)
                        Text(CardBranding.other.display).tag(CardBranding.other)
                    }
                    .pickerStyle(.navigationLink)
                    if cardBranding == .other {
                        TextField("Name des Zahlungsanbieters", text: $cardBrandingOther)
                    }
                }
                .disabled(!isEditing)
                .onChange(of: cardBranding) { _, newValue in
                    if newValue != .other {
                        cardBrandingOther = ""
                    }
                }
            }
            PaymentInfoView(
                paymentInfo: paymentInfo, //TODO: Replace with actual payment info
                isDisabled: !isEditing) { cardNumber in
                    // Update card branding based on card number
                    cardBranding = CardBranding.from(number: cardNumber)
                }
            LabeledTextField(
                label: "PIN",
                text: $pin,
                isSecure: true,
                withToggle: true,
                isDisabled: !isEditing)
            .keyboardType(.numberPad)
            ConditionsView(conditions: conditions)
                .disabled(!isEditing)
            LabeledTextField(
                label: "Zusatzinformationen",
                text: $freetext,
                isDisabled: !isEditing)
            .textContentType(.none)
        }
        .toolbar {
            if isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        if isNew {
                            navigationModel.path.removeLast()
                        } else {
                            reset()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                        isNew = false
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                }
            } else {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isEditing = true
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(isEditing)
        .navigationTitle(getTitle())
    }

    func getTitle() -> String {
        //TODO: Localize
        if isNew {
            return "Add Card"
        } else {
            if isEditing {
                return "Edit Card"
            }
            return "Card Details"
        }
    }
    func reset() {
        isEditing = false
        cardHolderName = currentCard.cardHolderName
        name = currentCard.name
        bank = currentCard.bank
        pin = currentCard.additionals.pin
        freetext = currentCard.additionals.freeText
        cardType = currentCard.cardType
        cardBranding = currentCard.cardBranding
        if currentCard.cardBranding == .other {
            cardBrandingOther = currentCard.customBranding ?? ""
        } else {
            cardBrandingOther = ""
        }
    }

    func save() {
        isEditing = false
        let updatedCard = Card(
            id: currentCard.id,
            name: name,
            cardHolderName: cardHolderName,
            bank: bank,
            paymentInfo: paymentInfo,
            cardType: cardType,
            cardBranding: cardBranding,
            customBranding: cardBranding == .other ? cardBrandingOther : nil,
            conditions: conditions,
            additionals: .init(pin: pin, freeText: freetext)
        )
        keychainAccessor.save(card: updatedCard)
        self.currentCard = updatedCard
    }
}

#Preview {
    NavigationStack {
        CardEditView(card: Card.amex)
    }
}
