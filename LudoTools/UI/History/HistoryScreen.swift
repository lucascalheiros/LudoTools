//
//  HistoryScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 27/08/25.
//

import SwiftUI
import Kingfisher

struct HistoryScreen: View {

    @StateObject var viewModel = HistoryVM()

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()
                ScrollView {
                    LazyVStack {
                        ForEach(Array(viewModel.matches.enumerated()), id: \.element.id) { index, match in
                            HStack {
                                KFImage.url(URL(string: match.game.thumb))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Text(match.game.name)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text((match.duration?.formatTimeSpan() ?? "") + " " + (match.date.formatISODate() ?? ""))
                                    Text("\(match.players.count) players")
                                }
                            }.onAppear {
                                if index == viewModel.matches.count - 10 {
                                    viewModel.loadMore()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("History")
        }
    }
}
