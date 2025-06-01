//
//  InterstitialAdManager.swift
//  Cuisine de chez nous
//
//  Created by Omar Doucouré on 2025-01-03.
//

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif
import SwiftUI

public class InterstitialAdManager: NSObject, FullScreenContentDelegate, ObservableObject {
    private var interstitial: InterstitialAd?
    private var adUnitID: String

    var onAdDidDismiss: (() -> Void)?

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }

    public func loadAd() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            print("Interstitial ad loaded successfully.")
        }
    }

    @MainActor
    public func showAd(from rootViewController: UIViewController, onAdDidDismiss: @escaping () -> Void) {
        guard let interstitial = interstitial else {
            print("Interstitial ad is not ready.")
            onAdDidDismiss() // Proceed immediately if ad isn't ready
            return
        }
        self.onAdDidDismiss = onAdDidDismiss
        interstitial.present(from: rootViewController)
        AnalyticsWrapper.shared.trackEvent("show_interstitial_ad")
    }

    // MARK: - FullScreenContentDelegate
    public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Ad dismissed.")
       // loadAd() // Reload a new ad
        onAdDidDismiss?()
    }

    public func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present ad: \(error.localizedDescription)")
        onAdDidDismiss?() // Proceed if the ad fails to present
    }
}
