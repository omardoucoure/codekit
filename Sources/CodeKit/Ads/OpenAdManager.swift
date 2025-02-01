//
//  OpenAdsManager.swift
//  Cuisine de chez nous
//
//  Created by Omar Doucouré on 2025-02-01.
//

import UIKit
import GoogleMobileAds

@MainActor
final class OpenAdsManager: NSObject {
    static let shared = OpenAdsManager()

    private var appOpenAd: GADAppOpenAd?
    private var loadTime: Date?

    private override init() {
        super.init()
    }

    /// Loads an App Open Ad using the provided ad unit ID.
    func loadAd(with adUnitID: String) {
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: adUnitID, request: request) { [weak self] (ad, error) in
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
    var isAdAvailable: Bool {
        guard let _ = appOpenAd, let loadTime = loadTime else { return false }
        // Consider ad valid for 4 hours.
        return Date().timeIntervalSince(loadTime) < (4 * 3600)
    }

    /// Presents the App Open Ad if available.
    /// - Parameter viewController: The view controller to present the ad from.
    func showAdIfAvailable(from viewController: UIViewController) {
        if isAdAvailable {
            appOpenAd?.present(fromRootViewController: viewController)
        } else {
            // Optionally, you can load a new ad here if needed.
            print("Ad is not available. Consider preloading a new ad.")
        }
    }
}

// MARK: - GADFullScreenContentDelegate

extension OpenAdsManager: GADFullScreenContentDelegate {

    nonisolated func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
            self.appOpenAd = nil
            // Reload the ad as needed. You might want to store the ad unit ID if it's dynamic.
        }
    }

    nonisolated func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            print("Ad failed to present full screen content with error: \(error.localizedDescription)")
            self.appOpenAd = nil
            // Reload the ad if necessary.
        }
    }

    nonisolated func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
            print("Ad recorded an impression.")
        }
    }
}
