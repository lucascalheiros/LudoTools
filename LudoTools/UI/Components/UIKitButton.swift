//
//  UIKitButton.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import SwiftUI
import UIKit

struct UIKitButton: UIViewRepresentable {
    let uiImage: UIImage?
    let title: String
    let onTap: () -> Void

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        if let uiImage {
            button.setImage(uiImage, for: .normal)
        }
        button.layer.cornerRadius = 8
        button.addTarget(context.coordinator, action: #selector(Coordinator.handleTap), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.setTitle(title, for: .normal)
        if let uiImage {
            uiView.setImage(uiImage, for: .normal)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }

    class Coordinator {
        let onTap: () -> Void
        init(onTap: @escaping () -> Void) {
            self.onTap = onTap
        }

        @objc func handleTap() {
            onTap()
        }
    }
}
