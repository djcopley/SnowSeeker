//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Daniel Copley on 2/19/23.
//

import Foundation

class Favorites: ObservableObject {
    @Published var resorts: Set<String>

    private static let saveKey = "Favorites"
    
    init() {
        let storedFavorites = UserDefaults.standard.object(forKey: Self.saveKey) as? [String] ?? []
        resorts = Set(storedFavorites)
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    private func save() {
        UserDefaults.standard.set(Array<String>(resorts), forKey: Self.saveKey)
    }
}
