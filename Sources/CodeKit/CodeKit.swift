// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct NotificationViewModifier: ViewModifier {
    private let onNotification: (String) -> Void

    public init(onNotification: @escaping (String) -> Void) {
        self.onNotification = onNotification
    }

    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationHandler.shared.$latestNotification) { notification in
                guard let notification else { return }
                let userInfo = notification.notification.request.content.userInfo
                let decoder = JSONDecoder()
                do {
                    let data = try JSONSerialization.data(withJSONObject: userInfo)
                    let payload = try decoder.decode(WonderPushNotification.self, from: data)
                    onNotification(payload.wp.targetUrl)
                } catch {
                    print(error)
                }
            }
    }
}

public class NotificationHandler: ObservableObject {
    public nonisolated(unsafe) static let shared = NotificationHandler()
    @Published private(set) var latestNotification: UNNotificationResponse? = .none

    public func handle(notification: UNNotificationResponse) {
        self.latestNotification = notification
    }

    public init() {}

}

