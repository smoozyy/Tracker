//  TrackerColor.swift
//  Tracker
//  Created by Антон on 25.09.2026.

import UIKit

enum TrackerColor: String, CaseIterable {
    case color1 = "ColorSection 1"
    case color2 = "ColorSection 2"
    case color3 = "ColorSection 3"
    case color4 = "ColorSection 4"
    case color5 = "ColorSection 5"
    case color6 = "ColorSection 6"
    case color7 = "ColorSection 7"
    case color8 = "ColorSection 8"
    case color9 = "ColorSection 9"
    case color10 = "ColorSection 10"
    case color11 = "ColorSection 11"
    case color12 = "ColorSection 12"
    case color13 = "ColorSection 13"
    case color14 = "ColorSection 14"
    case color15 = "ColorSection 15"
    case color16 = "ColorSection 16"
    case color17 = "ColorSection 17"
    case color18 = "ColorSection 18"
    
    var color: UIColor {
        return UIColor(named: rawValue) ?? .clear
    }
}
