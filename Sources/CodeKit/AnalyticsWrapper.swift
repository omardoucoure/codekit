//
//  AnalyticsWrapper.swift
//  CodeKit
//
//  Created by Omar Doucouré on 2025-01-07.
//

import Foundation
#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif

/// A thread-safe analytics wrapper for Firebase Analytics
public final class AnalyticsWrapper: @unchecked Sendable {
    public static let shared = AnalyticsWrapper()

    private init() {} // Private initializer to enforce singleton

    /// Tracks an event with optional parameters.
    /// - Parameters:
    ///   - name: The name of the event.
    ///   - parameters: Additional data to include with the event (default: empty).
    public func trackEvent(_ name: String, parameters: [String: Any] = [:]) {
        // Log to Firebase Analytics
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent(name, parameters: parameters)
        #endif

        // Debug log
        print("Analytics Event Logged: \(name), Parameters: \(parameters)")
    }

    /// Tracks a screen view.
    /// - Parameter screenName: The name of the screen.
    public func trackScreen(_ screenName: String) {
        #if canImport(FirebaseAnalytics)
        Analytics.setScreenName(screenName, screenClass: nil)
        Analytics.logEvent("screen_view", parameters: ["screen_name": screenName])
        #endif

        // Debug log
        print("Screen Tracked: \(screenName)")
    }

    /// Sets a user property.
    /// - Parameters:
    ///   - property: The name of the user property.
    ///   - value: The value of the user property.
    public func setUserProperty(_ property: String, value: String) {
        #if canImport(FirebaseAnalytics)
        Analytics.setUserProperty(value, forName: property)
        #endif

        // Debug log
        print("User Property Set: \(property) = \(value)")
    }
}
