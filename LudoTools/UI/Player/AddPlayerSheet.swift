//
//  AddPlayerSheet.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 29/08/25.
//

import SwiftUI

struct AddPlayerSheet: View {
    @State var addedPlayerInfo: AddedPlayerInfo = AddedPlayerInfo()
    var onAdd: ((AddedPlayerInfo) -> Void)?

    var body: some View {
        VStack {
            Text("Add Player")
                .padding()
                .font(.title)

            TextField("Name*", text: $addedPlayerInfo.name)
                .padding()

            TextField("Ludopedia ID", text: $addedPlayerInfo.ludopediaId)
                .padding()

            Spacer()
            Button("Add") {
                onAdd?(addedPlayerInfo)
            }
            .disabled(addedPlayerInfo.name.isEmpty)
            .padding()
        }
    }
}

struct AddedPlayerInfo {
    var name: String
    var ludopediaId: String

    init() {
        self.name = ""
        self.ludopediaId = ""
    }
}

#Preview {
    AddPlayerSheet()
}
