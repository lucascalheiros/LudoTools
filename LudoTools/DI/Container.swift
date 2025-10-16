//
//  Container.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

final class Container: Resolver {
    private var factories: [Key: ObjectScopedFactory] = [:]
    private var instances: [Key: ReferenceWrapper<Any>] = [:]

    private func invalidate(forKey key: Key) {
        instances.removeValue(forKey: key)
    }

    func invalidate<T>(_ type: T.Type, _ name: String? = nil) {
        invalidate(forKey: Key(type, name))
    }

    func register<T>(_ scope: ScopeOption, _ type: T.Type, _ name: String? = nil, _ factory: @escaping Factory) {
        let key = Key(type, name)
        factories[key] = ObjectScopedFactory(scope: scope, factory: factory)
        invalidate(forKey: key)
    }

    func register<T>(_ scope: ScopeOption, _ type: T.Type, _ name: String?, _ factory: @escaping () -> T) {
        register(scope, type, name) { _ in
            factory()
        }
    }

    func register<T>(_ scope: ScopeOption, _ type: T.Type, _ factory: @escaping Factory) {
        register(scope, type, nil, factory)
    }

    func register<T>(_ scope: ScopeOption, _ type: T.Type, _ factory: @escaping () -> T) {
        register(scope, type, nil) { _ in
            factory()
        }
    }

    func resolve<T>(_ type: T.Type, _ name: String? = nil) -> T {
        resolve(type, name, scope: nil)
    }

    func resolve<T>(_ type: T.Type, _ name: String? = nil, scope: Scope? = nil) -> T {
        let key = Key(type, name)
        guard let objectScopedFactory = factories[key] else {
            fatalError("No factory registered for \(type)")
        }
        let factory = objectScopedFactory.factory
        switch objectScopedFactory.scope {

        case .scoped:
            guard let scope else {
                fatalError("\(type) registered as scoped dependency, but not used in a scoped context")
            }
            return scope.instances[key]?.value as? T ?? {
                let instance = factory(scope)
                scope.instances[key] = ReferenceWrapper(.strong, instance)
                return instance as! T
            }()

        case .singleton:
            return instances[key]?.value as? T ?? {
                let instance = factory(self)
                instances[key] = ReferenceWrapper(.strong, instance)
                return instance as! T
            }()

        case .weakSingleton:
            return instances[key]?.value as? T ?? {
                let instance = factory(self)
                instances[key] = ReferenceWrapper(.strong, instance)
                return instance as! T
            }()

        case .factory:
            return factory(self) as! T

        case .weakScoped:
            guard let scope else {
                fatalError("\(type) registered as scoped dependency, but not used in a scoped context")
            }
            return scope.instances[key]?.value as? T ?? {
                let instance = factory(scope)
                scope.instances[key] = ReferenceWrapper(.weak, instance)
                return instance as! T
            }()
        }
    }

    func newScope() -> Scope {
        return Scope(container: self)
    }

    enum ScopeOption {
        case scoped
        case weakScoped
        case singleton
        case weakSingleton
        case factory
    }

    typealias Factory = (Resolver) -> Any

    final class Scope: Resolver {
        private let container: Container
        fileprivate var instances: [Key: ReferenceWrapper<Any>] = [:]

        init(container: Container) {
            self.container = container
        }

        func resolve<T>(_ type: T.Type, _ name: String?) -> T {
            return container.resolve(type, name, scope: self)
        }
    }
}

fileprivate struct Key: Hashable {
    let objectIdentifier: ObjectIdentifier
    let name: String?

    init(_ objectIdentifier: ObjectIdentifier, _ name: String?) {
        self.objectIdentifier = objectIdentifier
        self.name = name
    }

    init(_ type: any Any.Type, _ name: String?) {
        self.objectIdentifier = ObjectIdentifier(type)
        self.name = name
    }
}

fileprivate struct ObjectScopedFactory {
    let scope: Container.ScopeOption
    let factory: Container.Factory
}
