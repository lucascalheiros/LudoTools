//
//  DateTimeFormat.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 15/10/25.
//

import Foundation

extension String {
    func formatISODate() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date =  inputFormatter.date(from: self) else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

extension Int {
    func formatTimeSpan() -> String? {
        let hours = (self % 3600) / 60
        let minutes = self % 60

        if hours > 0 {
            return String(format: "%02dh%02dm", hours, minutes)
        } else {
            return String(format: "%02dm", minutes)
        }
    }
}
