//
//  InterstitialAdManager.swift
//  Cuisine de chez nous
//
//  Created by Omar Doucouré on 2025-01-03.
//

import GoogleMobileAds
import SwiftUI

public class InterstitialAdManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    private var interstitial: GADInterstitialAd?
    private var adUnitID: String

    public init(interstitial: GADInterstitialAd? = nil, adUnitID: String) {
        self.interstitial = interstitial
        self.adUnitID = adUnitID
    }

    public func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: adUnitID,
            request: request
        ) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            print("Interstitial ad loaded successfully.")
        }
    }

    public func showAd(from rootViewController: UIViewController) {
        guard let interstitial = interstitial else {
            print("Interstitial ad is not ready.")
            return
        }
        interstitial.present(fromRootViewController: rootViewController)
    }

    // MARK: - GADFullScreenContentDelegate
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad dismissed. Reloading a new ad.")
        loadAd() // Reload the ad after dismissal
    }
}
