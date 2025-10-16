//
//  AnyHashableKey.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import Foundation

struct AnyHashableKey: Hashable {
    private let value: AnyHashable

    init<T: Hashable>(_ value: T) {
        self.value = AnyHashable(value)
    }

    static func == (lhs: AnyHashableKey, rhs: AnyHashableKey) -> Bool {
        lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
}
