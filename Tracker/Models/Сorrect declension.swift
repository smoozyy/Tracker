//  Сorrect declension.swift
//  Tracker
//  Created by Антон on 22.09.2026.

import Foundation
extension Int {
    func daysString() -> String {
        let remainder10 = self % 10
        let remainder100 = self % 100
    
        if (11...14).contains(remainder100) {
            return "\(self) дней"
        }
        
        switch remainder10 {
        case 1:
            return "\(self) день"
        case 2, 3, 4:
            return "\(self) дня"
        default:
            return "\(self) дней"
        }
    }
}

