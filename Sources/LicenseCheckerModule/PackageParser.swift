import Foundation

public struct PackageParser {
    private let workspaceState: WorkspaceState
    private let APACHE_TEXT = "TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION"
    private let MIT_TEXT = "Permission is hereby granted, free of charge"
    private let BSD_TEXT = "Redistribution and use in source and binary forms"
    private let ZLIB_TEXT = "This software is provided 'as-is', without any express"
    private let BORINGSSL_TEXT = "BoringSSL is a fork of OpenSSL"

    public init?(url: URL) {
        guard let data = try? Data(contentsOf: url),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data)
        else { return nil }
        self.workspaceState = workspaceState
    }

    public func parse(with checkoutsPath: String) -> [Acknowledgement] {
        return workspaceState.object.dependencies.map { dependency in
            let components = dependency.packageRef.location.components(separatedBy: "/")
            let repoName = components.last!.replacingOccurrences(of: ".git", with: "")
            let dirURL = URL(fileURLWithPath: checkoutsPath).appendingPathComponent(repoName)
            let license = extractLicense(dirURL: dirURL)
            return Acknowledgement(libraryName: dependency.packageRef.name,
                                   license: license ?? "unknown")
        }.sorted { $0.libraryName.lowercased() < $1.libraryName.lowercased() }
    }

    public func extractLicense(dirURL: URL) -> String? {
        let fm = FileManager.default
        let contents = (try? fm.contentsOfDirectory(atPath: dirURL.path)) ?? []
        let _licenseURL = contents.map { content in
            return dirURL.appendingPathComponent(content)
        }.filter { contentURL in
            if contentURL.lastPathComponent.lowercased().hasPrefix("license") {
                var isDiractory: ObjCBool = false
                fm.fileExists(atPath: contentURL.path, isDirectory: &isDiractory)
                return isDiractory.boolValue == false
            }
            return false
        }.first
        guard let licenseURL = _licenseURL, var text = try? String(contentsOf: licenseURL) else {
            return nil
        }
        text = text.replace(of: #"(  +|\n)"#, with: " ")
        var license: String? = nil
        if text.contains("Apache License") || text.contains(APACHE_TEXT) {
            license = "Apache"
        }
        if text.contains("MIT License") || text.contains(MIT_TEXT) {
            license = "MIT"
        }
        if text.contains(BSD_TEXT) {
            license = "BSD"
        }
        if text.contains(ZLIB_TEXT) {
            license = "zlib"
        }
        if text.contains(BORINGSSL_TEXT) {
            license = "BoringSSL"
        }
        return license
    }
}
