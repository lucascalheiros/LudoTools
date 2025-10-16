//
//  PlayerScoreView.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 15/10/25.
//

import SwiftUI
import SwiftData

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
                    .foregroundStyle(.black)
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
                .fill(.surface)
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
