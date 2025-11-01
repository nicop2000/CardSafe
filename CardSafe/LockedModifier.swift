import SwiftUI
import LocalAuthentication

struct LockedModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase

    @Binding private var isLocked: Bool
    @State private var password = ""
    @State private var passwordSet: Bool
    @State private var faceIdFailed: Bool = false
    @State private var showWrongPasswordAlert = false
    let keychainAccess = KeychainAccessor()
    @State var timerToLock: Timer?

    init(isLocked: Binding<Bool>) {
        self._passwordSet = State(initialValue: keychainAccess.isLockPasswordSet())
        self._isLocked = isLocked
    }

    func body(content: Content) -> some View {
        Group {
            if passwordSet {
                if isLocked {
                    VStack(spacing: 20) {
                        Text("🔒 Gesperrt")
                            .font(.largeTitle)
                            .bold()

                        SecureField("Enter password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        Button("Unlock") {
                            if keychainAccess.checkIfLockPasswordCorrect(password) {
                                unlock()
                            } else {
                                showWrongPasswordAlert = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .alert("Wrong password", isPresented: $showWrongPasswordAlert) {
                            Button("OK", role: .cancel) {}
                        }
                        if LAContext().biometryType != .none {
                            Button {
                                authenticate()
                            } label: {
                                Label("Use Face ID", systemImage: "faceid")
                            }
                        }
                    }
                    .padding()
                    .transition(.opacity)
                } else {
                    content
                }
            } else {
                PasswordSetupView(passwordSet: $passwordSet)
            }
            
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .inactive {
                withAnimation {
                    timerToLock = .scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { _ in
                        lock()
                    })
                }
            } else if newPhase == .active {
                timerToLock?.invalidate()
                timerToLock = nil
                if !isLocked || faceIdFailed {
                    return
                }
                authenticate()
            }
        }
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            faceIdFailed = true
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock with Face ID") { success, err in
            DispatchQueue.main.sync {
                if let err {
                    print("Authentication failed: \(err.localizedDescription)")
                    faceIdFailed = true
                }
                if success {
                    unlock()
                }
            }
        }
    }

    func lock() {
        withAnimation {
            self.isLocked = true
            self.password = ""
            self.timerToLock?.invalidate()
            self.timerToLock = nil
        }
    }

    func unlock() {
        withAnimation {
            self.isLocked = false
            self.password = ""
            self.faceIdFailed = false
        }
    }
}

extension View {
    public func locked(isLocked: Binding<Bool>) -> some View {
        modifier(LockedModifier(isLocked: isLocked))
    }
}
