//
//  DataQualifier.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

enum DataQualifier: String {
    case ludopediaRequestBuilder
}

extension Inject {
    init(_ type: T.Type, _ name: DataQualifier) {
        self.init(type, name.rawValue)
    }
}

extension Container {
    func register<T>(_ scope: ScopeOption, _ type: T.Type, _ name: DataQualifier, _ factory: @escaping () -> T) {
        register(scope, type, name.rawValue) { _ in
            factory()
        }
    }
}
