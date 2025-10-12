//
//  BasicGameInfo.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/09/25.
//

protocol BasicGameInfo: Hashable {
    var id: Int { get }
    var name: String { get }
    var thumb: String { get }
    var link: String { get }
}
