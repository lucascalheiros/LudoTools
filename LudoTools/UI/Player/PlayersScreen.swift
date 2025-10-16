//
//  PlayersScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 29/08/25.
//

import SwiftData
import SwiftUI
import Kingfisher

struct PlayersScreen: View {

    @Query(sort: [SortDescriptor(\PlayerInfo.name, order: .forward)]) var players: [PlayerInfo]

    @State var playerEditableSheetState: PlayerEditableSheet.Context? = nil

    @Environment(\.modelContext) private var context

    var dismiss: () -> Void

    var body: some View {
        NavigationView {
            List(players) { info in
                HStack {
                    if let thumb = info.ludoUser?.thumb {
                        KFImage.url(URL(string: thumb))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    Text(info.name)
                    if let ludoUser = info.ludoUser?.user {
                        Text("(\(ludoUser))")
                    }
                }
                .contextMenu {
                    Button {
                        playerEditableSheetState = .editPlayer(info)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        context.delete(info)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Players")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        playerEditableSheetState = .addPlayer
                    }
                }
            }
        }
        .sheet(item: $playerEditableSheetState) {
            PlayerEditableSheet(sheetContext: $0) { _ in
                playerEditableSheetState = nil
            }.presentationDetents([.medium])
        }
    }
}

struct PlayerInfoView: View {
    var playerInfo: PlayerInfo
    
    var body: some View {
    }
}
