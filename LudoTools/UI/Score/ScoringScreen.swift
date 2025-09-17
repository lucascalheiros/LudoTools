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
            ForEach(Array(scoreBoard().enumerated()), id: \.element.name) { index, entry in
                let (pos, name, score) = entry

                VStack(alignment: .leading, spacing: 0) {
                    Text("\(pos). (\(score)) \(name)")
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if index < scoreBoard().count - 1 {
                        Divider()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray)
        }
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
    func button(_ text: String, onTap: () -> Void) -> some View {
        Button("Add Player") {

        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.primaryContainer)
        }
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea().onTapGesture {
                UIApplication.shared.hideKeyboard()
            }

            ScrollView {
                LazyVStack {
                    header()
                        .padding()
                    ForEach(scoringEntity.playerScoreEntries) { value in
                        PlayerScoreView(entry: value) {
                            context.delete(value)
                        }
                        .padding(.horizontal)
                    }
                    HStack {
                        button("Add Player") {

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
    }

    private func addEntryForGuest() {
        scoringEntity.playerEntriesAdded += 1
        scoringEntity.playerScoreEntries.append(PlayerScoreEntry(type: .guest, playerName: "Player \(scoringEntity.playerEntriesAdded)"))
    }

    private func addEntryForPlayer(_ player: PlayerInfo) {
        scoringEntity.playerEntriesAdded += 1
        scoringEntity.playerScoreEntries.append(PlayerScoreEntry(type: .registered, playerInfo: player))
    }
}

struct PlayerScoreView: View {
    @Bindable var entry: PlayerScoreEntry
    var incrementDecrementOptions: [Int] = [-1, -5, -10, 10, 5, 1]
    var onRemoved: () -> Void

    var body: some View {
        VStack {
            HStack {
                switch entry.type {
                case .guest:
                    TextField("", text: $entry.playerName)
                        .fixedSize()
                case .registered:
                    Label("\(entry.displayName)", systemImage: "checkmark.circle.fill")
                }
                Spacer()
                TextField("", value: $entry.score, format: .number)
                    .keyboardType(.numberPad)
                    .fixedSize()
            }
            .font(.title)
            LazyHStack {
                ForEach(incrementDecrementOptions, id: \.self) { value in
                    Button((value > 0 ? "+" : "") + String(value)) {
                        entry.score += value
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(value > 0 ? Color.green : Color.red)
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray)
        }
        .contextMenu {
            Button(role: .destructive) {
                onRemoved()
            } label: {
                Label("Remove", systemImage: "trash")
            }
        }
    }
}
