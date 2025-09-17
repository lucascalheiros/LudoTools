//
//  ScoreListScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 29/08/25.
//

import SwiftUI
import SwiftData

struct ScoreListScreen: View {
    @Query(sort: [SortDescriptor(\ScoringEntity.date, order: .reverse)]) var scores: [ScoringEntity]
    @Environment(\.modelContext) private var context
    var dismiss: () -> Void

    @State private var navPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                LazyVStack {
                    ForEach(Array(scores.enumerated()), id: \.element.id) { index, score in
                        VStack {
                            HStack {
                                Text(score.name)
                                Spacer()
                                Text(score.date.formatted())
                            }
                            HStack {
                                Text("\(score.playerScoreEntries.count) players")
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button(role: .destructive) {
                                context.delete(score)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            navPath.append(NavTarget.newScore(score))
                        }
                        if index < scores.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.surface)
                }
                .padding()
            }
            .navigationTitle("Scores")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("New score") {
                        let score = ScoringEntity()
                        context.insert(score)
                        navPath.append(NavTarget.newScore(score))
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .navigationDestination(for: NavTarget.self) { target in
                switch target {
                case .newScore(let entity):
                    ScoringScreen(scoringEntity: entity)
                }
            }
        }
    }
}

private enum NavTarget: Identifiable, Hashable {
    case newScore(ScoringEntity)

    var id: Int {
        self.hashValue
    }
}


private extension Date {
    func formatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
