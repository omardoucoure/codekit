//
//  WonderPushNotification.swift
//  SwiftPress
//
//  Created by Omar Doucouré on 2024-11-24.
//

import Foundation

// MARK: - Main Model
public struct WPNotification: Codable {
    let wp: WP
    let aps: APS

    enum CodingKeys: String, CodingKey {
        case wp = "_wp"
        case aps
    }
}

// MARK: - WP
public struct WP: Codable {
    let accessToken: String
    let receipt: Bool
    let c: String?
    let receiptUsingMeasurements: Bool
    let targetUrl: String
    let attachments: [Attachment]
    let n: String
    let alert: Alert?
    let reporting: Reporting
    let type: String
}

// MARK: - Attachment
public struct Attachment: Codable {
    let url: String
    let type: String
}

// MARK: - Alert
struct Alert: Codable {
    let buttons: [String]?
}

// MARK: - Reporting
public struct Reporting: Codable {
    let campaignId: String?
    let notificationId: String
}

// MARK: - APS
public struct APS: Codable {
    let mutableContent: Int
    let alert: APSAlert
    let sound: String

    enum CodingKeys: String, CodingKey {
        case mutableContent = "mutable-content"
        case alert
        case sound
    }
}

// MARK: - APSAlert
public struct APSAlert: Codable {
    let title: String
    let body: String
}
