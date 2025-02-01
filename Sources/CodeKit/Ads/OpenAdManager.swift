import UIKit
import GoogleMobileAds

@MainActor
final class OpenAdsManager: NSObject {

    static let shared = OpenAdsManager()

    private var appOpenAd: GADAppOpenAd?
    private var loadTime: Date?

    // Private initializer to enforce singleton usage
    private override init() {
        super.init()
    }

    // MARK: - Ad Loading

    /// Loads an App Open Ad.
    func loadAd() {
        let adUnitID = "YOUR_APP_OPEN_AD_UNIT_ID" // Replace with your ad unit id
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
        guard let appOpenAd = appOpenAd, let loadTime = loadTime else { return false }
        // Consider ad valid for 4 hours.
        let maxAdAge: TimeInterval = 4 * 3600
        return Date().timeIntervalSince(loadTime) < maxAdAge
    }

    // MARK: - Ad Presentation

    /// Presents the App Open Ad if available.
    /// - Parameter viewController: The view controller to present the ad from.
    func showAdIfAvailable(from viewController: UIViewController) {
        if isAdAvailable {
            appOpenAd?.present(fromRootViewController: viewController)
        } else {
            loadAd()
        }
    }
}

// MARK: - GADFullScreenContentDelegate

extension OpenAdsManager: GADFullScreenContentDelegate {

    nonisolated func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
            self.appOpenAd = nil
            self.loadAd()
        }
    }

    nonisolated func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            print("Ad failed to present full screen content with error: \(error.localizedDescription)")
            self.appOpenAd = nil
            self.loadAd()
        }
    }

    nonisolated func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
            print("Ad recorded an impression.")
        }
    }
}
