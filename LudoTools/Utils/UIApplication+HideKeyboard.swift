//
//  UIApplication+HideKeyboard.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
