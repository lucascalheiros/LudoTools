//
//  Item.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
