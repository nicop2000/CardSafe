import Foundation

struct Additionals: Codable, Hashable {
    let pin: String
    let freeText: String

    init(
        pin: String,
        freeText: String
    ) {
        self.pin = pin
        self.freeText = freeText
    }

    init() {
        self.pin = ""
        self.freeText = ""
    }
}
