public enum LicenseType: String {
    case apache = "Apache"
    case mit = "MIT"
    case bsd = "BSD"
    case zlib = "zlib"
    case boringSSL = "BoringSSL"
    case unknown = "unknown"

    public var lowercased: String {
        self.rawValue.lowercased()
    }
}
