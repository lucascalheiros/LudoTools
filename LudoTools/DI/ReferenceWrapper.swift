//
//  ReferenceWrapper.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

class ReferenceWrapper<T> {

    private let reference: Reference
    private weak var weakValue: AnyObject?
    private var strongValue: T?

    var value: T? {
        switch reference {
        case .weak:
            weakValue as? T
        case .strong:
            strongValue
        }
    }

    init(_ reference: Reference, _ value: T?) {
        self.reference = reference
        switch reference {
        case .weak:
            weakValue = value as AnyObject
        case .strong:
            strongValue = value
        }
    }

    enum Reference {
        case weak
        case strong
    }
}

