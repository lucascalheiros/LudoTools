//
//  GamePickerView.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 16/09/25.
//

import Kingfisher
import SwiftUI

struct GamePickerView: View {

    @StateObject private var viewModel: GamePickerVM = .init()

    var query: GameQueryOptions

    var onSelected: ((BasicGameInfo) -> Void)?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(
                    Array(viewModel.games.enumerated()),
                    id: \.element.id
                ) { index, game in
                    HStack {
                        KFImage.url(URL(string: game.thumb))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text(game.name)
                            .onAppear {
                                if index < viewModel.games.count - 10 {
                                    viewModel.loadMoreGames()
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) 
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelected?(game)
                    }
                    if index < viewModel.games.count - 1 {
                        Divider()
                    }
                }
                if viewModel.isLoadingMoreGames {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }.padding()
        }
        .onAppear {
            viewModel.updateQuery(query)
        }
        .onChange(of: query) { old, new in
            viewModel.updateQuery(new)
        }
    }
}

enum GameQueryOptions: Hashable {
    case collection(GetCollectionParams)
    case allGames(GetGamesParams)
}
