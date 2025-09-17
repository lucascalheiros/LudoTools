//
//  UserDefault.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?

    var wrappedValue: T? {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
