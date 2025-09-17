//
//  HomeScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 27/08/25.
//

import SwiftUI
import Combine
import Kingfisher

struct HomeScreen: View {
    @Environment(\.modelContext) private var context

    @State private var currentNavTarget: NavTarget?

    @State private var game: BasicGameInfo?

    @StateObject private var homeVM: HomeVM = .init()

    @ViewBuilder
    func gameSearchInput() -> some View {
        HStack {
            TextField("Search games", text: $homeVM.searchText)
            if !homeVM.searchText.isEmpty {
                Button {
                    homeVM.searchText = ""
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .padding()
        .foregroundColor(Color.onTertiaryContainer)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.tertiaryContainer)
        }
        .padding()
    }

    @ViewBuilder
    func mainOptionsGrid() -> some View {
        Grid {
            GridRow {
                card("New match") {
                    currentNavTarget = .newMatch
                }
                card("New score") {
                    let score = ScoringEntity()
                    context.insert(score)
                    currentNavTarget = .newScore(score)
                }
            }
            GridRow {
                card("Players") {
                    currentNavTarget = .players
                }
                card("Scores") {
                    currentNavTarget = .scores
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea().onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }

                VStack {
                    mainOptionsGrid()
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .centerLastTextBaseline ) {
                            if !homeVM.searchText.isEmpty {
                                GamePickerView(
                                    query: GameQueryOptions.allGames(.init(search: homeVM.searchText, type: .base, baseGameId: nil))
                                )
                                .frame(maxHeight: 300)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.surface)
                                )
                                .shadow(radius: 4)
                                .zIndex(1)
                            }
                        }
                    gameSearchInput()
                }
            }
            .navigationTitle("Home")
        }
        .fullScreenCover(item: $currentNavTarget) { target in
            currentNavScreen(target)
        }
    }

    private func dismissNav() {
        currentNavTarget = nil
    }

    @ViewBuilder
    private func currentNavScreen(_ target: NavTarget) -> some View {
        switch target {
        case .newMatch:
            NavigationView {
                MatchScreen(game: $game)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { dismissNav() }) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                    }
            }
        case .players:
            PlayersScreen { dismissNav() }
        case .newScore(let score):
            NavigationView {
                ScoringScreen(scoringEntity: score)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { dismissNav() }) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                    }
            }
        case .scores:
            ScoreListScreen { dismissNav() }
        }
    }

    @ViewBuilder
    private func card(_ text: String, _ onTap: (() -> Void)? = nil) -> some View {
        Text(text)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.primaryContainer)
            }
            .onTapGesture {
                onTap?()
            }
    }
}

#Preview {
    HomeScreen()
}

private enum NavTarget: Identifiable, Hashable {
    case newMatch
    case players
    case newScore(ScoringEntity)
    case scores

    var id: Int {
        self.hashValue
    }
}
