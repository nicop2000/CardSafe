import Foundation

struct Expiration: Codable, Hashable {
    let month: Int
    let year: Int

    func asString() -> String {
        let monthString = String(format: "%02d", month)
        return "\(monthString)/\(year)"
    }
}
