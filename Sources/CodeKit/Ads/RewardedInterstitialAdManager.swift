//
//  RewardedInterstitialAdManager.swift
//  CodeKit
//
//  Created by Omar Doucouré on 2025-02-01.
//

import GoogleMobileAds
import SwiftUI

public class RewardedInterstitialAdManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    private var adUnitID: String
    var onAdDidDismiss: (() -> Void)?
    var onAdDidReward: (() -> Void)?

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }

    // MARK: - Load Ad
    public func loadAd() {
        let request = GADRequest()
        GADRewardedInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
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
    public func showAd(from rootViewController: UIViewController, onAdDidReward: @escaping () -> Void, onAdDidDismiss: @escaping () -> Void) {
        guard let rewardedInterstitialAd = rewardedInterstitialAd else {
            print("Rewarded interstitial ad is not ready.")
            onAdDidDismiss() // Proceed immediately if the ad isn't ready
            return
        }

        self.onAdDidReward = onAdDidReward
        self.onAdDidDismiss = onAdDidDismiss

        rewardedInterstitialAd.present(fromRootViewController: rootViewController) {
            print("User earned a reward.")
            self.onAdDidReward?()
        }

        AnalyticsWrapper.shared.trackEvent("show_rewarded_interstitial_ad")
    }

    // MARK: - GADFullScreenContentDelegate
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded interstitial ad dismissed.")
        onAdDidDismiss?()
    }

    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present rewarded interstitial ad: \(error.localizedDescription)")
        onAdDidDismiss?() // Proceed if the ad fails to present
    }
}
