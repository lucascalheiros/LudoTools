//
//  Card.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 27/08/25.
//

import SwiftUI

struct Card<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .padding(.horizontal)
    }
}
