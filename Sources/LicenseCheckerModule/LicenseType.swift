public enum LicenseType: String {
    case apache = "Apache"
    case mit = "MIT"
    case bsd = "BSD"
    case zlib = "zlib"
    case boringSSL = "BoringSSL"
    case unknown = "unknown"

    public var lowercased: String {
        rawValue.lowercased()
    }

    init(text: String) {
        let types: [LicenseType : String] = [
            .apache: "Apache License",
            .mit: "MIT License",
            .bsd: "Redistribution and use in source and binary forms",
            .zlib: "This software is provided 'as-is', without any express",
            .boringSSL: "BoringSSL is a fork of OpenSSL"
        ]
        self = types.compactMap { key, value -> (LicenseType, String.Index)? in
            guard let range = text.range(of: value) else { return nil }
            return (key, range.lowerBound)
        }
        .sorted { $0.1 < $1.1 }
        .first?.0 ?? .unknown
    }
}
