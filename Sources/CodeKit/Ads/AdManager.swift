//
//  AdManager.swift
//  CodeKit
//
//  Created by Omar Doucouré on 2025-01-05.
//

import GoogleMobileAds

public class AdManager {
    // Singleton instance for convenience
    @MainActor public static let shared = AdManager()

    private init() {}

    /// Initialize the Google Mobile Ads SDK
    public func initializeSDK(completion: (() -> Void)? = nil) {
        MobileAds.shared.start { _ in
            print("Google Mobile Ads SDK initialized successfully.")
            completion?()
        }
    }
}
