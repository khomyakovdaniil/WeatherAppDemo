//
//  WeatherResponse.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 12.06.2024.
//

import Foundation

import Foundation
import SwiftUI

struct WeatherResponse: Codable {
    let data: WeatherData
}
// MARK: - DataClass
struct WeatherData: Codable {
    let currentWeather: [CurrentWeather]
    let dailyWeather: [WeatherElement]

    enum CodingKeys: String, CodingKey {
        case currentWeather = "current_condition"
        case dailyWeather = "weather"
    }
}

struct CurrentWeather: Codable {
    private let tempC, tempF: String
    private let humidity: String
    private let weatherDesc: [StringValue]

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_C"
        case tempF = "temp_F"
        case weatherDesc, humidity
    }

    var weatherDescription: String {
        weatherDesc.first?.value ?? ""
    }

    var tempFormatted: String {
        return tempC + "º"
    }

    var humidityFormatted: String {
        return humidity + "%"
    }

}

struct StringValue: Codable {
    let value: String
}

struct WeatherElement: Codable, Identifiable {
    let id = UUID()
    let hourly: [Hourly]
    private let date: String
    private let maxtempC, mintempC: String

    enum CodingKeys: String, CodingKey {
        case date, maxtempC, mintempC, hourly
    }

    var highTempFormatted: String {
        maxtempC + "º"
    }

    var lowTempFormatted: String {
        mintempC + "º"
    }

    var day: String {
        date.dayOfWeek() ?? ""
    }
}

// MARK: - Hourly
struct Hourly: Codable, Identifiable {
    let id = UUID()
    let weatherCode: String
    private let time, tempC, tempF: String

    enum CodingKeys: String, CodingKey {
        case time, tempC, tempF, weatherCode
    }

    var timeFormatted: String {
        time.formatHourlyTime() ?? ""
    }

    var tempFormatted: String {
        return tempC + "º"
    }
}
