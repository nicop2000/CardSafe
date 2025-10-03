//
//  PasswordSetupView.swift
//  CardSafe
//
//  Created by Nico Petersen on 12.06.25.
//


import SwiftUI

struct PasswordSetupView: View {
    @Binding var passwordSet: Bool
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showMismatchAlert = false
    let keychain = KeychainAccessor()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Group {
                    Text("Set a password to protect your cards. ")
                    + Text("This password will be used unlock the app")
                    Text("Hint: You can change it later in the settings")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 1)
                Spacer()
                SecureField("Enter password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Confirm password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Save Password") {
                    guard !password.isEmpty, password == confirmPassword else {
                        showMismatchAlert = true
                        return
                    }
                    keychain.saveLockPassword(password)
                    passwordSet = true
                }
                .buttonStyle(.borderedProminent)
                .alert("Passwords don't match", isPresented: $showMismatchAlert) {
                    Button("Try Again", role: .cancel) { }
                }
                Group {
                    Text("Make sure to remember your password, as it cannot be recovered if forgotten")
                    Text("You can also use Face ID or Touch ID for convenience")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 5)
                Spacer()
            }
            .padding()
            .navigationTitle("CardSafe Setup")
        }
    }
}
