//
//  Resolver.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//


protocol Resolver {
    func resolve<T>(_ type: T.Type, _ name: String?) -> T
}
extension Resolver {
    func resolve<T>(_ type: T.Type) -> T {
        self.resolve(type, nil)
    }
}
