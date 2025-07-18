import Foundation

extension String {
    func replacing(of regexPattern: String, with replacement: String) -> String {
        replacingOccurrences(of: regexPattern, with: replacement, options: .regularExpression, range: range(of: self))
    }
}
