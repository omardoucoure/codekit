//
//  AdBannerView.swift
//  Cuisine de chez nous
//
//  Created by Omar Doucouré on 2025-01-03.
//

import SwiftUI
import GoogleMobileAds

public struct AdBannerView: UIViewRepresentable {
    private let adUnitID: String
    private let sizeBanner: GADAdSize
    @Binding private var isAdReady: Bool

    public init(adUnitID: String, sizeBanner: GADAdSize = GADAdSizeMediumRectangle, isAdReady: Binding<Bool> = .constant(true)) {
        self.adUnitID = adUnitID
        self.sizeBanner = sizeBanner
        self._isAdReady = isAdReady
    }

    public func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: sizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = UIApplication.shared.getRootViewController()
        bannerView.delegate = context.coordinator
        bannerView.load(GADRequest())
        return bannerView
    }

    public func updateUIView(_ uiView: GADBannerView, context: Context) {
        // No updates needed for the banner
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, @preconcurrency GADBannerViewDelegate {
        private let parent: AdBannerView

        init(_ parent: AdBannerView) {
            self.parent = parent
        }

        @MainActor public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("Ad successfully loaded.")
            parent.isAdReady = true
        }

        @MainActor public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("Failed to load ad: \(error.localizedDescription)")
            parent.isAdReady = false
        }
    }
}
