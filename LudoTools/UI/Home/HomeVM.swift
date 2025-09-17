//
//  HomeVM.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 04/09/25.
//

import Combine
import SwiftUI

@MainActor
class HomeVM: ObservableObject {

    @Inject(GamesRepository.self)
    private var gamesRepository: GamesRepository

    var cancellable: Set<AnyCancellable> = []

    @Published var searchText = "" 

}
