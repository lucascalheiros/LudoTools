//
//  PlayerPickerBottomSheet.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 14/10/25.
//

import SwiftUI

struct PlayerPickerBottomSheet: View {
    var selectOption: PlayerPickerView.SelectOption
    var onSelected: (([PlayerInfo]) -> Void)?
    @State var showAddPlayerSheet: Bool = false

    var body: some View {
        VStack {
            PlayerPickerView(
                selectOption: selectOption,
                onSelected: onSelected
            )
            Button("Add new") {
                showAddPlayerSheet = true
            }
        }
        .sheet(isPresented: $showAddPlayerSheet) {
            PlayerEditableSheet(sheetContext: .addPlayer) { _ in
                showAddPlayerSheet = false
            }
            .presentationDetents([.medium])
        }
    }
}
