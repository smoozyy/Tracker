//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Антон on 19.11.2026.
//


import AppMetricaCore
import Foundation

final class AnalyticsService {

    static let shared = AnalyticsService()

    private init() {}

    func reportEvent(
        name: String,
        parameters: [AnyHashable: Any]? = nil
    ) {
        AppMetrica.reportEvent(
            name: name,
            parameters: parameters,
            onFailure: { error in
                print("Analytics error: \(error.localizedDescription)")
            }
        )
    }
}
