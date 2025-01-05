//
//  AdBannerView.swift
//  Cuisine de chez nous
//
//  Created by Omar Doucouré on 2025-01-03.
//

import SwiftUI
import GoogleMobileAds

public struct AdBannerView: UIViewRepresentable {
    let adUnitID: String
    var sizeBanner: GADAdSize = GADAdSizeMediumRectangle

    public init(adUnitID: String, sizeBanner: GADAdSize = GADAdSizeMediumRectangle) {
        self.adUnitID = adUnitID
        self.sizeBanner = sizeBanner
    }
    
    public func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: sizeBanner)

        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        bannerView.load(GADRequest())
        return bannerView
    }

    public func updateUIView(_ uiView: GADBannerView, context: Context) {
        // No update needed for the banner
    }
}
