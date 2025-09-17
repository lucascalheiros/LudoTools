//
//  CollectionScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 27/08/25.
//

import SwiftUI
import Kingfisher

struct CollectionScreen: View {
    @State private var playerCount = 0
    @State private var gameType = GameType.all
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var userGames: [GameCollectionModel] = []
    var params: GetCollectionParams {
        .init(collectionType: .collection, search: nil, type: gameType, sort: nil, playerCount: playerCount == 0 ? nil : playerCount)
    }

    @Inject(GameCollectionRepository.self)
    var repository: GameCollectionRepository

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()
                VStack {
                    HStack {
                        Picker("Game type", selection: $gameType) {
                            Text("All").tag(GameType.all)
                            Text("Base").tag(GameType.base)
                            Text("Expansion").tag(GameType.expansion)
                        }.pickerStyle(.segmented)
                        Picker("Games for", selection: $playerCount) {
                            Label("Any", systemImage: "person.3.fill").tag(0)
                            Label("1", systemImage: "person.fill").tag(1)
                            Label("2", systemImage: "person.2.fill").tag(2)
                            Label("3", systemImage: "person.3.fill").tag(3)
                            ForEach(4...15, id: \.self) {
                                Label("\($0)", systemImage: "person.3.fill").tag($0)
                            }
                        }
                        .frame(minWidth: UIScreen.main.bounds.width / 4, alignment: .trailing)
                    }

                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(Array(userGames.enumerated()), id: \.element.id) { index, game in
                                VStack {
                                    KFImage.url(URL(string: game.thumb))
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(1, contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    Text(game.name)
                                        .lineLimit(1)
                                }
                                .padding()
                                .onAppear {
                                    if index == userGames.count - 10 {
                                        Task {
                                            await repository.loadMoreGames(params)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Spacer()
                }
            }
            .navigationTitle("Collection")
        }.task(id: params) {
            await repository.loadMoreGames(params)
        }
        .onReceive(repository.gamesPublisher(params).receive(on: RunLoop.main).eraseToAnyPublisher()) {
            userGames = $0
        }
    }
}
