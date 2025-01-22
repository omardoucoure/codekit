// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct NotificationViewModifier: ViewModifier {
    private let onNotification: (String) -> Void
    @State private var showAlert = false

    public init(onNotification: @escaping (String) -> Void) {
        self.onNotification = onNotification
    }

    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationHandler.shared.$latestNotification) { notification in
                guard let notification = notification else { return }
                let decoder = JSONDecoder()
                do {
                    let data = try JSONSerialization.data(withJSONObject: notification)
                    let payload = try decoder.decode(WPNotification.self, from: data)
                    if let url = URL(string: payload.wp.targetUrl) {
                        let lastPathComponent = url.lastPathComponent
                        onNotification(lastPathComponent)
                    } else {
                        onNotification(payload.wp.targetUrl)
                    }

                } catch {
                    print(error)
                    showAlert = true
                }
            }
            .alert("Erreur", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Impossible d'afficher la notification")
            }
    }
}

public class NotificationHandler: ObservableObject {
    public nonisolated(unsafe) static let shared = NotificationHandler()
    @Published private(set) var latestNotification: [AnyHashable : Any]? = nil

    public func handle(notification: [AnyHashable : Any]) {
        self.latestNotification = notification
    }

    public init() {}

}

