@testable import LicenseCheckerModule

extension LicenseType {
    var containerDirectoryName: String {
        switch self {
        case .apache:
            "SourcePackagesApache"
        case .mit:
            "SourcePackagesMIT"
        case .bsd:
            "SourcePackagesBSD"
        case .zlib:
            "SourcePackagesZlib"
        case .boringSSL:
            "SourcePackagesBoringSSL"
        case .unknown:
            ""
        }
    }
    
    var packageDirectoryName: String {
        switch self {
        case .apache:
            "apache-package"
        case .mit:
            "mit-package"
        case .bsd:
            "bsd-package"
        case .zlib:
            "zlib-package"
        case .boringSSL:
            "boringssl-package"
        case .unknown:
            ""
        }
    }
}
