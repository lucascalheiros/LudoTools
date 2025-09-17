//
//  MainScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 27/08/25.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            CollectionScreen()
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
                    Text("Collection")
                }

            HistoryScreen()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }

            SettingsScreen()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tint(Color.primaryCustom)
    }
}
