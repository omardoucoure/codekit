//
//  WonderPushNotification.swift
//  SwiftPress
//
//  Created by Omar Doucouré on 2024-11-24.
//

import Foundation

struct WonderPushNotification: Codable {
    let wp: WP
    let aps: APS

    enum CodingKeys: String, CodingKey {
        case wp = "_wp"
        case aps
    }
}

struct WP: Codable {
    let accessToken: String
    let alert: WPAlert
    let attachments: [Attachment]?
    let c: String?
    let n: String
    let receipt: Int
    let receiptUsingMeasurements: Int
    let reporting: Reporting
    let targetUrl: String
    let type: String
}

struct WPAlert: Codable {
    let buttons: String?
}

struct Attachment: Codable {
    let type: String
    let url: String
}

struct Reporting: Codable {
    let campaignId: String?
    let notificationId: String
}

struct APS: Codable {
    let alert: APSAlert
    let mutableContent: Int
    let sound: String

    enum CodingKeys: String, CodingKey {
        case alert
        case mutableContent = "mutable-content"
        case sound
    }
}

struct APSAlert: Codable {
    let body: String
    let title: String
}
