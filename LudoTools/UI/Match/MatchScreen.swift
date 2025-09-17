//
//  MatchScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/09/25.
//

import SwiftUI
import Kingfisher

struct MatchScreen: View {

    @Binding var game: BasicGameInfo?

    @State var expansions: [BasicGameInfo] = []

    @State var date = Date()

    @State var isMatchFinished = false

    @State var showGamePicker = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Game")
                        Spacer()
                        Text(game?.name ?? "Not selected")
                        if let thumb = game?.thumb {
                            KFImage.url(URL(string: thumb))
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        showGamePicker = true
                    }
                    Divider()
                    HStack {
                        Text("Expansions")
                        Spacer()
                        Text("Expansions name")
                    }
                    .padding(.horizontal)
                    Divider()
                    Toggle(
                        "Is finished",
                        isOn: $isMatchFinished
                    )
                    .padding(.horizontal)
                    Divider()
                    DatePicker(
                        "Start at",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .padding(.horizontal)
                    Divider()
                    if isMatchFinished {
                        DatePicker(
                            "Finished at",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .padding(.horizontal)
                        Divider()
                    }
                    HStack {
                        Text("Score")
                        Spacer()
                        Text("Game name")
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.surface)
                }
                .padding()
                .animation(.easeInOut(duration: 0.3), value: isMatchFinished)
            }
            .sheet(isPresented: $showGamePicker) {
                GamePickerBottomSheet(
                    onSelected: {
                        showGamePicker = false
                        game = $0
                    }
                )
            }
        }
        .navigationTitle("Match")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct GamePickerBottomSheet: View {
    var onSelected: ((BasicGameInfo) -> Void)?

    var body: some View {
        VStack {
            GamePickerView(
                query: GameQueryOptions.collection(.init(collectionType: .collection, search: nil, type: .base, sort: nil, playerCount: nil)),
                onSelected: onSelected
            )
        }
    }
}
