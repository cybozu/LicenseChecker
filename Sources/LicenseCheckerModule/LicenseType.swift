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
        let types: [LicenseType : [String]] = [
            .apache: ["Apache License", "Apache Licence"],
            .mit: ["MIT License", "MIT Licence"],
            .bsd: ["Redistribution and use in source and binary forms"],
            .zlib: ["This software is provided 'as-is', without any express"],
            .boringSSL: ["BoringSSL is a fork of OpenSSL"]
        ]
        self = types.compactMap { key, value -> (LicenseType, String.Index)? in
            guard let range = value
                .compactMap({ text.range(of: $0) })
                .min(by: { $0.lowerBound < $1.lowerBound }) else {
                return nil
            }
            return (key, range.lowerBound)
        }
        .min(by: { $0.1 < $1.1 })?.0 ?? .unknown
    }
}
