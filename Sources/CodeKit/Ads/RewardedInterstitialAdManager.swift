//
//  RewardedInterstitialAdManager.swift
//  CodeKit
//
//  Created by Omar Doucouré on 2025-02-01.
//

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif
import SwiftUI

public class RewardedInterstitialAdManager: NSObject, FullScreenContentDelegate, ObservableObject {
    private var rewardedInterstitialAd: RewardedInterstitialAd?
    private var adUnitID: String
    var onAdDidDismiss: (() -> Void)?
    var onAdDidReward: (() -> Void)?

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }

    // MARK: - Load Ad
    public func loadAd() {
        let request = Request()
        RewardedInterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.rewardedInterstitialAd = ad
            self?.rewardedInterstitialAd?.fullScreenContentDelegate = self
            print("Rewarded interstitial ad loaded successfully.")
        }
    }

    // MARK: - Show Ad
    @MainActor
    public func showAd(from rootViewController: UIViewController, onAdDidReward: @escaping () -> Void, onAdDidDismiss: @escaping () -> Void) {
        guard let rewardedInterstitialAd = rewardedInterstitialAd else {
            print("Rewarded interstitial ad is not ready.")
            onAdDidDismiss() // Proceed immediately if the ad isn't ready
            return
        }

        self.onAdDidReward = onAdDidReward
        self.onAdDidDismiss = onAdDidDismiss

        rewardedInterstitialAd.present(from: rootViewController) {
            print("User earned a reward.")
            self.onAdDidReward?()
        }

        AnalyticsWrapper.shared.trackEvent("show_rewarded_interstitial_ad")
    }

    // MARK: - FullScreenContentDelegate
    public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Rewarded interstitial ad dismissed.")
        onAdDidDismiss?()
    }

    public func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present rewarded interstitial ad: \(error.localizedDescription)")
        onAdDidDismiss?() // Proceed if the ad fails to present
    }
}
