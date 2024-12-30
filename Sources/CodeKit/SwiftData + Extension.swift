//
//  SwiftData + Extension.swift
//  CodeKit
//
//  Created by Omar Doucouré on 2024-12-30.
//

import SwiftData

public extension ModelContext {
    /// Save a generic `@Model` instance to the context.
    func save<T: AnyObject>(_ object: T) throws where T: PersistentModel {
        self.insert(object)
        try self.save()
    }

    /// Remove a generic `@Model` instance from the context.
    func remove<T: AnyObject>(_ object: T) throws where T: PersistentModel {
        self.delete(object)
        try self.save()
    }

    /// Retrieve all instances of a specific `@Model` type.
    func retrieveAll<T: PersistentModel>(_ type: T.Type) -> [T] {
        let fetchDescriptor = FetchDescriptor<T>()
        do {
            return try self.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch \(T.self): \(error)")
            return []
        }
    }
}
