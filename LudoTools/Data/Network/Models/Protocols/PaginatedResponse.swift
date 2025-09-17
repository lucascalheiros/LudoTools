//
//  PaginatedResponse.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 13/09/25.
//

protocol PaginatedResponse {
    associatedtype Item

    var total: Int { get }
    var content: [Item] { get }
}
