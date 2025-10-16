//
//  MatchScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/09/25.
//

import SwiftUI
import Kingfisher

struct MatchScreen: View {

    @StateObject var viewModel: MatchVM = .init()

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    gameSelectorSection()
                    expansionsSection()
                    playersSection()
                    VStack {
                        DatePicker(
                            "Start at",
                            selection: $viewModel.startDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .padding(.horizontal)
                        .frame(height: 30)
                        Divider()
                        if viewModel.isMatchFinished {
                            DatePicker(
                                "Finished at",
                                selection: $viewModel.finishedDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .padding(.horizontal)
                            .frame(height: 30)
                            Divider()
                        }
                        Toggle(
                            "Finished",
                            isOn: $viewModel.isMatchFinished
                        )
                        .padding(.horizontal)
                        .frame(height: 30)
                        Divider()
                        HStack {
                            Text("Score")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .frame(height: 30)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.surface)
                    }
                    .padding()
                    .animation(.easeInOut(duration: 0.3), value: viewModel.isMatchFinished)
                }
            }
            .sheet(item: $viewModel.sheetState) {
                switch $0 {
                case .gamePicker:
                    GamePickerBottomSheet(
                        query: GetGamesSlice.GameQueryOptions.collection(.init(collectionType: .collection, search: nil, type: .base, sort: nil, playerCount: nil)),
                        selectOptions: .single,
                        onSelected: { games in
                            viewModel.sheetState = nil
                            withAnimation {
                                viewModel.game = games.first
                            }
                        }
                    )

                case .expansionPicker(let gameId):
                    GamePickerBottomSheet(
                        query: GetGamesSlice.GameQueryOptions.allGames(.init(search: nil, type: .expansion, baseGameId: gameId)),
                        selectOptions: .multiple(currentSelection: viewModel.expansions),
                        onSelected: { games in
                            viewModel.sheetState = nil
                            withAnimation {
                                viewModel.expansions = games
                            }
                        }
                    )

                case .playerPicker:
                    PlayerPickerBottomSheet(
                        selectOption: .multiple(currentSelection: viewModel.players),
                        onSelected: { players in
                            viewModel.sheetState = nil
                            withAnimation {
                                viewModel.players = players
                            }
                        }
                    )
                }
            }
        }
        .navigationTitle("Match")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { }) {
                    Text("Save")
                }
                .disabled(viewModel.isSaveDisabled)
            }
        }
    }

    @ViewBuilder
    private func gameSelectorSection() -> some View {
        VStack {
            if let game = viewModel.game {
                KFImage.url(URL(string: game.thumb))
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(width: 100, height: 100)
                Text(game.name)
            } else {
                Image(systemName: "plus.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Select a game")
            }
        }
        .onTapGesture {
            viewModel.showGamePicker()
        }
    }

    @ViewBuilder
    private func expansionsSection() -> some View {
        if viewModel.game != nil {
            HStack {
                if !viewModel.expansions.isEmpty {
                    UIKitButton(uiImage: UIImage(systemName:  viewModel.showExpansions ? "chevron.up" : "chevron.down"), title: "\(viewModel.expansions.count) selected", onTap: {
                        withAnimation {
                            viewModel.showExpansions = !viewModel.showExpansions
                        }
                    })
                    .fixedSize()
                }
                Spacer()
                UIKitButton(uiImage: nil, title: "Select expansions", onTap: {
                    viewModel.showExpansionPicker()
                })
                .fixedSize()
            }
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.3), value: viewModel.showExpansions)
        }
        if viewModel.showExpansions {
            VStack {
                ForEach(viewModel.expansions, id: \.id) { exp in
                    HStack {
                        KFImage.url(URL(string: exp.thumb))
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: 40, height: 40)
                        Text(exp.name)
                        Spacer()
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.removeExpansion(exp)
                            }

                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func playersSection() -> some View {
        HStack {
            if !viewModel.players.isEmpty {
                UIKitButton(uiImage: UIImage(systemName:  viewModel.showPlayers ? "chevron.up" : "chevron.down"), title: "\(viewModel.players.count) selected", onTap: {
                    withAnimation {
                        viewModel.showPlayers = !viewModel.showPlayers
                    }
                })
                .fixedSize()
            }
            Spacer()
            UIKitButton(uiImage: nil, title: "Select players", onTap: {
                viewModel.showPlayerPicker()
            })
            .fixedSize()
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showPlayers)
        if viewModel.showPlayers {
            VStack {
                ForEach(viewModel.players, id: \.id) { exp in
                    HStack {
                        if let thumb = exp.ludoUser?.thumb {
                            KFImage.url(URL(string: thumb))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        Text(exp.name)
                        if let ludoUser = exp.ludoUser?.user {
                            Text("(\(ludoUser))")
                        }
                        Spacer()
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.removePlayer(exp)
                            }

                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    .frame(height: 40)
                }
            }
            .padding(.horizontal)
        }
    }
}
