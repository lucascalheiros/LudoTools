//
//  ModuleRegister.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

struct ModuleRegister {
    @ContainerWrapped
    var container: Container

    func register() {
        DataAssembler.assembly(container)
        DomainAssembler.assembly(container)
        UIAssembler.assembly(container)
    }
}
