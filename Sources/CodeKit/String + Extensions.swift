//
//  String + Extensions.swift
//  CodeKit
//
//  Created by Omar Doucouré on 2024-12-23.
//

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
