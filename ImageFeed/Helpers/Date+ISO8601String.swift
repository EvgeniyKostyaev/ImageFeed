//
//  Date+ISO8601String.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 15.04.2025.
//

import Foundation

extension Date {
    /// Поддерживает форматы:
    /// - "2025-03-25T11:00:28Z" (без миллисекунд)
    /// - "2025-03-25T11:00:28.123Z" (с миллисекундами)
    /// - "2025-03-25T11:00:28-04:00" (с временной зоной)
    static func from(iso8601String string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        
        if let date = formatter.date(from: string) {
            return date
        }
        
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)
    }
    
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
}
