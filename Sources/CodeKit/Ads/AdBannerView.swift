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
    private let sizeBanner: AdSize
    @Binding private var isAdReady: Bool

    public init(
        adUnitID: String,
        sizeBanner: AdSize = AdSizeMediumRectangle,
        isAdReady: Binding<Bool> = .constant(false)
    ) {
        self.adUnitID = adUnitID
        self.sizeBanner = sizeBanner
        self._isAdReady = isAdReady
    }

    public func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: sizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = UIApplication.shared.getRootViewController()
        bannerView.delegate = context.coordinator
        bannerView.load(Request())
        return bannerView
    }

    public func updateUIView(_ uiView: BannerView, context: Context) {
        // No updates needed for the banner
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, BannerViewDelegate {
        private let parent: AdBannerView

        init(_ parent: AdBannerView) {
            self.parent = parent
        }

        @MainActor public func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("Ad successfully loaded.")
            parent.isAdReady = true
        }

        @MainActor public func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("Failed to load ad: \(error.localizedDescription)")
            parent.isAdReady = false
        }
    }
}
