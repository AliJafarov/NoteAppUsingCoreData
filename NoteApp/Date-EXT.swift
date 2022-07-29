//
//  Date-EXT.swift
//  NoteApp
//
//  Created by Ali Jafarov on 24.07.22.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        return dateFormatter.string(from: self)
    }
}
