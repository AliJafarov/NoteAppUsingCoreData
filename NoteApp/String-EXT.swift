//
//  String-EXT.swift
//  NoteApp
//
//  Created by Ali Jafarov on 24.07.22.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        let result =  dateFormatter.date(from: self)
        
        return result
    }
}
