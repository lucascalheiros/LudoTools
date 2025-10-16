//
//  ScoringScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 29/08/25.
//

import SwiftUI
import SwiftData

struct ScoringScreen: View {
    @Bindable var scoringEntity: ScoringEntity

    @Environment(\.modelContext) private var context

    @State var showPlayerPicker = false

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea().onTapGesture {
                UIApplication.shared.hideKeyboard()
            }

            ScrollView {
                LazyVStack {
                    header()
                        .padding()
                    ForEach(scoringEntity.playerScoreEntries.sorted(by: { $0.displayName < $1.displayName})) { value in
                        PlayerScoreView(entry: value) {
                            scoringEntity.playerScoreEntries.removeAll(where: { $0 == value })
                        }
                        .padding(.horizontal)
                    }
                    HStack {
                        button("Add Player") {
                             showPlayerPicker = true
                        }
                        button("Add Guest") {
                            addEntryForGuest()
                        }
                    }
                    .foregroundColor(Color.onPrimaryContainer)
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(scoringEntity.name)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if scoringEntity.name.isEmpty {
                scoringEntity.name = "Unamed"
            }
        }
        .sheet(isPresented: $showPlayerPicker) {
            PlayerPickerBottomSheet(
                selectOption: .single,
                onSelected: { players in
                    showPlayerPicker = false
                    withAnimation {
                        players.forEach(addEntryForPlayer)
                    }
                }
            )
        }
    }

    func scoreBoard() -> [(pos: Int, name: String, score: Int)] {
        scoringEntity.sortedPlayerScoreEntries
            .enumerated()
            .flatMap { index, element in
                return element.players
                    .map { (index + 1, $0.displayName, element.score) }
            }
    }

    @ViewBuilder
    func playerResults() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            let scores = scoreBoard()
            ForEach(Array(scores.enumerated()), id: \.element.name) { index, entry in
                let (pos, name, score) = entry

                VStack(alignment: .leading, spacing: 0) {
                    Text("\(pos). (\(score)) \(name)")
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if index < scores.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack {
                playerResults()
                Spacer()
                VStack(alignment: .trailing) {
                    TextField("", text: $scoringEntity.name).fixedSize()
                    Button {
                        scoringEntity.toggleScoringType()
                    } label: {
                        switch scoringEntity.nonNullScoringType {
                        case .lessPoints:
                            Label("Less points", systemImage: "chevron.down.2")
                        case .morePoints:
                            Label("More points", systemImage: "chevron.up.2")
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder
    func button(_ text: String, onTap: @escaping () -> Void) -> some View {
        Button(text) {
            onTap()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.primaryContainer)
        }
    }

    private func addEntryForGuest() {
        scoringEntity.playerEntriesAdded += 1
        scoringEntity.playerScoreEntries.append(PlayerScoreEntry(type: .guest, playerName: "Player \(scoringEntity.playerEntriesAdded)"))
    }

    private func addEntryForPlayer(_ player: PlayerInfo) {
        if scoringEntity.players.contains(player) {
            return
        }
        scoringEntity.playerEntriesAdded += 1
        scoringEntity.playerScoreEntries.append(PlayerScoreEntry(type: .registered, playerInfo: player))
    }
}

