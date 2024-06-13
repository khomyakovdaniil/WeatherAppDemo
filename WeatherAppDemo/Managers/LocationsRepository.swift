//
//  LocationsRepository.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 12.06.2024.
//

import Foundation
import Combine

final class LocationsRepository {
        
    let userDefaults = UserDefaults.standard
    
    @Published var locations: [String] = []
    var defaultLocation: String = ""
    
    func saveLocations(_ locations: [String]) {
        userDefaults.set(locations, forKey: "locations")
    }

    private func getLocations() -> [String] {
        if let locations = userDefaults.stringArray(forKey: "locations") {
            return locations
        }
        return ["Current location"]
    }
    
    func saveDefaultLocation(_ location: String) {
        userDefaults.set(location, forKey: "default")
    }
    
    func getDefaultLocation() -> String {
        userDefaults.string(forKey: "default") ?? ""
    }
    
    func load() {
        locations = getLocations()
    }
    
    func saveLocation(_ location: String) {
        if !locations.contains(location) {
            locations.append(location)
        }
        saveLocations(locations)
    }
}
