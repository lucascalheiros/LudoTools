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

    var query: GetGamesSlice.GameQueryOptions

    var selectOptions: SelectOptions

    var onSelected: (([GameInfo]) -> Void)?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(
                    Array(viewModel.games.enumerated()),
                    id: \.element.id
                ) { index, game in
                    itemView(game)
                        .onAppear {
                            if index < viewModel.games.count - 10 {
                                viewModel.loadMoreGames()
                            }
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
            if case .multiple(let currentSelection) = selectOptions {
                currentSelection.forEach {
                    viewModel.selectionState[AnyHashableKey($0)] = (true, $0)
                }
            }
        }
        .onDisappear {
            if case .multiple = selectOptions {
                onSelected?(viewModel.selectionState.values.compactMap {
                    guard $0.0 else {
                        return nil
                    }
                    return $0.1
                })
            }
        }
        .onChange(of: query) { old, new in
            viewModel.updateQuery(new)
        }
    }

    @ViewBuilder
    private func multipleSelectionItem(_ game: GameInfo) -> some View {
        let anyKey = AnyHashableKey(game)
        Toggle(isOn: Binding(
            get: { viewModel.selectionState[anyKey]?.0 ?? false },
            set: { viewModel.selectionState[anyKey] = ($0, game) }
        )) {
            Text(game.name)
        }
    }

    @ViewBuilder
    private func singleSelectionItem(_ game: GameInfo) -> some View {
        HStack {
            KFImage.url(URL(string: game.thumb))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(game.name)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelected?([game])
        }
    }

    @ViewBuilder
    private func itemView(_ game: GameInfo) -> some View {
        switch selectOptions {
        case .multiple:
            multipleSelectionItem(game)
        case .single:
            singleSelectionItem(game)
        }
    }

}

extension GamePickerView {
    enum SelectOptions {
        case single
        case multiple(currentSelection: [GameInfo])
    }
}
