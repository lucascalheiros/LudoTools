//
//  GamePickerBottomSheet.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import SwiftUI

struct GamePickerBottomSheet: View {
    var query: GetGamesSlice.GameQueryOptions
    var selectOptions: GamePickerView.SelectOptions
    var onSelected: (([GameInfo]) -> Void)?

    var body: some View {
        VStack {
            GamePickerView(
                query: query,
                selectOptions: selectOptions,
                onSelected: onSelected
            )
        }
    }
}
