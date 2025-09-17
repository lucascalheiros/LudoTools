//
//  PlayersScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 29/08/25.
//

import SwiftUI

struct PlayersScreen: View {
    @State var playerInfoList: [PlayerInfo] = []
    @State var showAddPlayerSheet: Bool = false
    var dismiss: () -> Void

    var body: some View {
        NavigationView {
            List(playerInfoList) { info in
                HStack {
                    Text(info.name)
                    if info.ludopediaId.isNotEmpty {
                        Text("(\(info.ludopediaId))")
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
                        showAddPlayerSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showAddPlayerSheet) {
            AddPlayerSheet {
                playerInfoList.append(PlayerInfo(name: $0.name, ludopediaId: $0.ludopediaId))
                showAddPlayerSheet = false
            }.presentationDetents([.medium])
        }
    }
}

struct PlayerInfoView: View {
    var playerInfo: PlayerInfo
    
    var body: some View {
    }
}
