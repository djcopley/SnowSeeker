//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Daniel Copley on 2/19/23.
//

import Foundation

class Favorites: ObservableObject {
    @Published var resorts: Set<String>

    private let saveKey = "Favorites"
    
    init() {
        // load save data
        resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        
    }
}
