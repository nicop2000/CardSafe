import SwiftUI
import LocalAuthentication

struct LabeledTextField: View {
    let label: LocalizedStringKey
    @Binding var text: String
    @State private var isSecure: Bool = false
    let withToggle: Bool
    let shouldBeSecure: Bool
    let isDisabled: Bool

    init(
        label: LocalizedStringKey,
        text: Binding<String>,
        isSecure: Bool = false,
        withToggle: Bool = false,
        isDisabled: Bool = false) {
            if withToggle && !isSecure {
                assert(isSecure, "Cannot have a toggle without a secure field")
            }
            self.label = label
            self._text = text
            self.isSecure = isSecure
            self.shouldBeSecure = isSecure
            self.withToggle = withToggle
            self.isDisabled = isDisabled
        }
    @FocusState private var isFocused: Bool

    var shouldFloat: Bool {
        !text.isEmpty
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Text(label)
                .foregroundStyle(shouldFloat ? Color.primary : Color.gray)
                .scaleEffect(shouldFloat ? 0.75 : 1.0, anchor: .leading)
                .offset(y: shouldFloat ? -17.5 : -1)
                .animation(.easeOut(duration: 0.2), value: shouldFloat)
            Group {
                HStack {
                    if isSecure {
                        SecureField("", text: $text)
                            .focused($isFocused)
                            .disabled(isDisabled)
                    } else {
                        TextField("", text: $text)
                            .focused($isFocused)
                            .disabled(isDisabled)
                    }
                    if shouldBeSecure && withToggle {
                        Button {
                            toggleSecure()
                        } label: {
                            Image(systemName: "eye")
                                .symbolVariant(isSecure ? .fill : .slash)
                        }
                    }
                }
            }
        }
        .padding(.top, 5)
        .padding(.bottom, -2.5)
        .animation(.default, value: isFocused)
        .padding(.vertical, 5)
    }

    func toggleSecure() {
        if isSecure {
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrCompanion, localizedReason: "Unlock to view sensitive information") { success, error in
                if let error = error {
                    print("Authentication failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        isSecure = true
                    }
                    return
                }
                if success {
                    DispatchQueue.main.async {
                        isSecure = false
                    }
                } else {
                    DispatchQueue.main.async {
                        isSecure = true
                    }
                }
            }
        } else {
            isSecure = true
        }
    }
}

#Preview {
    @Previewable @State var text = "Test 123"
    @Previewable @State var text2 = ""
    let tf =  LabeledTextField(
        label: "Card Number",
        text: $text,
        isSecure: false,
        withToggle: false
    )
    let tf2 =  LabeledTextField(
        label: "Card Number",
        text: $text2,
        isSecure: false,
        withToggle: false
    )
    return List {
        Section{
            tf
            tf2
        }
    }
}
