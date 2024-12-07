//
//  BackgroundTimerModifier.swift
//  CodeKit
//
//  Created by Omar Doucouré on 2024-12-06.
//


import SwiftUI
import Combine

extension View {
    /// Adds a background timer to the view, triggering the specified action after a defined duration when the app is in the background.
    /// - Parameters:
    ///   - timeInterval: The duration (in seconds) before the action is triggered while in the background.
    ///   - onBackgroundRefresh: A closure to execute after the specified duration.
    /// - Returns: The view with background timer handling applied.
    func backgroundRefresh(timeInterval: TimeInterval = 300, onBackgroundRefresh: @escaping @Sendable () async -> Void) -> some View {
        modifier(BackgroundTimerModifier(timeInterval: timeInterval, onBackgroundRefresh: onBackgroundRefresh))
    }
}

private struct BackgroundTimerModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    @State private var backgroundTask: Task<Void, Never>?

    let timeInterval: TimeInterval
    let onBackgroundRefresh: @Sendable () async -> Void

    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    startBackgroundTimer()
                } else if newPhase == .active {
                    cancelBackgroundTimer()
                }
            }
    }

    private func startBackgroundTimer() {
        cancelBackgroundTimer() // Ensure no duplicate timers

        backgroundTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(timeInterval * 1_000_000_000))
            if !Task.isCancelled {
                await onBackgroundRefresh()
            }
        }
    }

    private func cancelBackgroundTimer() {
        backgroundTask?.cancel()
        backgroundTask = nil
    }
}
