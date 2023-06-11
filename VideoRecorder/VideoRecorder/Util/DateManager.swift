//
//  DateManager.swift
//  VideoRecorder
//
//  Created by 김성준 on 2023/06/10.
//

import Foundation

final class DateManager {
    static let shared = DateManager()
    
    private let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM .dd"
        
        return dateFormatter
    }()
    
    
    private init() {
        
    }
    
    func today() -> String {
        let dateText = dateFormatter.string(from: Date())
        
        return dateText
    }
}
