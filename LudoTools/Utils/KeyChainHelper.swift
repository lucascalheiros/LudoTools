//
//  KeyChainHelper.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import Security
import Foundation
import Combine

@propertyWrapper
struct Keychain {
    private let key: String
    private var cancellables: [AnyCancellable] = []
    private var cachedValue: String?

    init(key: String) {
        self.key = key
    }

    var wrappedValue: String? {
        get {
            KeychainHelper.get(key)
        }
        set {
            guard let newValue else {
                KeychainHelper.delete(key)
                return
            }
            KeychainHelper.save(newValue, forKey: key)
        }
    }
}

private struct KeychainHelper {

    private static let keyInvalidationSubject = PassthroughSubject<String, Never>()
    static let keyInvalidationPublisher: any Publisher<String, Never> = keyInvalidationSubject

    @discardableResult
    static func save(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        // Delete any existing item
        let queryDelete = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        SecItemDelete(queryDelete)

        // Add new item
        let queryAdd = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        let status = SecItemAdd(queryAdd, nil)
        keyInvalidationSubject.send(key)
        return status == errSecSuccess
    }

    static func get(_ key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }

        return string
    }

    static func delete(_ key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        SecItemDelete(query)
        keyInvalidationSubject.send(key)
    }
}
