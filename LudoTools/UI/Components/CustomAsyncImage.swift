//
//  CustomAsyncImage.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 08/09/25.
//

import SwiftUI

struct CustomAsyncImage<I: View, P: View>: View {
    @State private var image: UIImage? = nil
    var url: URL
    var content: (Image) -> I
    var placeholder: () -> P

    init(url: URL, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else {
                placeholder()
            }
        }
        .onAppear {
            Task {
                self.image = nil
                do {
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue("image/*", forHTTPHeaderField: "Accept")
                    let (data, _) = try await URLSession.shared.data(for: request)
                    if let uiImage = UIImage(data: data) {
                        self.image = uiImage
                    }
                } catch {
                    self.image = nil
                }
            }
        }
    }
}
