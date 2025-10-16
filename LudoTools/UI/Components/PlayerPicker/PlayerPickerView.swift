//
//  PlayerPickerView.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 18/09/25.
//

import SwiftData
import SwiftUI
import Kingfisher

struct PlayerPickerView: View {

    @Query(sort: [SortDescriptor(\PlayerInfo.name, order: .forward)]) var players: [PlayerInfo]

    var selectOption: SelectOption = .single
    
    var onSelected: (([PlayerInfo]) -> Void)?

    @State var playerSelectionState: [String: Bool] = [:]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(
                    Array(players.enumerated()),
                    id: \.element.name
                ) { index, player in
                    switch selectOption {
                    case .single:
                        playerView(player)
                            .onTapGesture {
                                if case .single = selectOption {
                                    onSelected?([player])
                                }
                            }

                    case .multiple:
                        Toggle(isOn: Binding(
                            get: { playerSelectionState[player.name] ?? false },
                            set: { playerSelectionState[player.name] = $0 }
                        )) {
                            playerView(player)
                        }
                    }
                    if index < players.count - 1 {
                        Divider()
                    }
                }
            }.padding()
        }
        .onAppear {
            if case .multiple(let currentSelection) = selectOption {
                currentSelection.forEach {
                    playerSelectionState[$0.name] = true
                }
            }
        }
        .onDisappear {
            if case .multiple = selectOption {
                onSelected?(players.filter { playerSelectionState[$0.name] ?? false })
            }
        }
    }

    @ViewBuilder
    private func playerView(_ player: PlayerInfo) -> some View {
        HStack {
            if let thumb = player.ludoUser?.thumb {
                KFImage.url(URL(string: thumb))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            Text(player.name)
            if let ludoUser = player.ludoUser?.user {
                Text("(\(ludoUser))")
            }
        }
    }

    enum SelectOption {
        case single
        case multiple(currentSelection: [PlayerInfo])
    }
}
