//
//  UIAssembler.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

struct UIAssembler: Assembler {
    static func assembly(_ container: Container) {
        container.register(.scoped, GetGameCollectionSlice.self, GetGameCollectionSlice.init)
        container.register(.scoped, GetGamesFromAllSlice.self, GetGamesFromAllSlice.init)
        container.register(.scoped, GetGamesSlice.self, GetGamesSlice.init)
    }
}
