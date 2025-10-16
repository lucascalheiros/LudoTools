//
//  LudoUserPickerView.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 18/09/25.
//

import SwiftUI
import Kingfisher

struct LudoUserPickerView: View {

    @StateObject private var viewModel: LudoUserPickerVM = .init()

    var query: String

    var onSelected: ((UserModel) -> Void)?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(
                    Array(viewModel.users.enumerated()),
                    id: \.element.id
                ) { index, game in
                    HStack {
                        KFImage.url(URL(string: game.thumb))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text(game.user)
                            .onAppear {
                                if index < viewModel.users.count - 10 {
                                    viewModel.loadMoreGames()
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelected?(game)
                    }
                    if index < viewModel.users.count - 1 {
                        Divider()
                    }
                }
                if viewModel.isLoadingMoreGames {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }.padding()
        }
        .onAppear {
            viewModel.updateQuery(query)
        }
        .onChange(of: query) { old, new in
            viewModel.updateQuery(new)
        }
    }
}
