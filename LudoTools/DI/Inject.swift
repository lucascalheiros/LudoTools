//
//  Inject.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

@propertyWrapper
struct Inject<T> {
    @ContainerWrapped
    var container: Container

    var name: String?

    var wrappedValue: T {
        container.resolve(T.self, name)
    }

    init(_ type: T.Type, _ name: String? = nil) {
        self.name = name
    }
}

@propertyWrapper
struct ContainerWrapped {
    static var container: Container = .init()

    var wrappedValue: Container {
        Self.container
    }

    static func setContainer(_ container: Container) {
        Self.container = container
    }
}
