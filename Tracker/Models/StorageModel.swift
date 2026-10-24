//
//  StorageModel.swift
//  Tracker
//
//  Created by Антон on 24.10.2026.
//

import Foundation

final class StorageModel {
    static let shared = StorageModel()
    
    var hasSwitchToTabBarController: Bool {
        get {
            UserDefaults.standard.bool(forKey: "hasSwitchToTabBarController" )
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasSwitchToTabBarController")
        }
    }
}
