//
//  LocationResponse.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 12.06.2024.
//

import Foundation

// MARK: - Search Location
struct LocationResponse: Decodable {
    let searchAPI: SearchAPI

    enum CodingKeys: String, CodingKey {
        case searchAPI = "search_api"
    }
}

// MARK: - SearchAPI
struct SearchAPI: Decodable {
    let result: [Place]
}

// MARK: - Place
struct Place: Decodable {
    private let areaName: [StringValue]
    private let country: [StringValue]
    private let region: [StringValue]
    
    enum CodingKeys: String, CodingKey {
        case areaName, country, region
    }
    
    var fullString: String {
        "\(areaName.first?.value ?? "Unknown"), \(region.first?.value ?? ""), \(country.first?.value ?? "")"
    }
    
}
