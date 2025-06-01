//
//  OpenAdsManager.swift
//  Cuisine de chez nous
//
//  Created by Omar Doucouré on 2025-02-01.
//

import UIKit
#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

@MainActor
public final class OpenAdsManager: NSObject {
    public static let shared = OpenAdsManager()

    private var appOpenAd: AppOpenAd?
    private var loadTime: Date?
    private var adUnitID: String?

    /// Loads an App Open Ad using the provided ad unit ID.
    public func loadAd(with adUnitID: String) {
        let request = Request()
        self.adUnitID = adUnitID
        AppOpenAd.load(with: adUnitID, request: request) { [weak self] (ad, error) in
            if let error = error {
                print("Failed to load app open ad: \(error.localizedDescription)")
                return
            }

            self?.appOpenAd = ad
            self?.loadTime = Date()
            self?.appOpenAd?.fullScreenContentDelegate = self
        }
    }

    /// Checks if the ad is available and not expired.
    public var isAdAvailable: Bool {
        guard let _ = appOpenAd, let loadTime = loadTime else {
            reloadAdIfNeeded()  // Automatically reload if not available
            return false
        }

        let isValid = Date().timeIntervalSince(loadTime) < (1 * 3600)
        if !isValid {
            reloadAdIfNeeded()  // Reload if expired
        }

        return isValid
    }

    private func reloadAdIfNeeded() {
        if let adUnitID {
            loadAd(with: adUnitID)
        }
    }

    /// Presents the App Open Ad if available.
    /// - Parameter viewController: The view controller to present the ad from.
    public func showAdIfAvailable(from viewController: UIViewController) {
        if isAdAvailable {
            appOpenAd?.present(from: viewController)
        } else {
            if let adUnitID {
                loadAd(with: adUnitID)
            }

            // Optionally, you can load a new ad here if needed.
            print("Ad is not available. Consider preloading a new ad.")
        }
    }
}

// MARK: - GADFullScreenContentDelegate

extension OpenAdsManager: FullScreenContentDelegate {

    public nonisolated func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Task { @MainActor in
            self.appOpenAd = nil
            // Reload the ad as needed. You might want to store the ad unit ID if it's dynamic.
            if let adUnitID {
                loadAd(with: adUnitID)
            }
        }
    }

    public nonisolated func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            print("Ad failed to present full screen content with error: \(error.localizedDescription)")
            self.appOpenAd = nil
            // Reload the ad if necessary.
            if let adUnitID {
                loadAd(with: adUnitID)
            }
        }
    }

    public nonisolated func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        Task { @MainActor in
            print("Ad recorded an impression.")
        }
    }
}
