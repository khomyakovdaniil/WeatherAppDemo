//
//  Constants.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 13.06.2024.
//

import Foundation

struct Constants {
    
    struct Strings {
        static let currentLocation = "Current location"
        static let saveLocation = "Save location"
        static let hourlyForecastHeader = "Today"
        static let weeklyForecastHeader = "Forecast"
        static let searchBarPrompt = "Search city by name"
        static let noData = "N/A"
    }
    
    enum Api {
        case searchLocation(location: String)
        case fetchWeather(location: String)

        private static let sharedQuery: [QueryKey: String] = [.apiKey: apiKey, .format: "json"]

        private var baseURL: URL {
            switch self {
                case .searchLocation, .fetchWeather:
                return Api.apiUrl
            }
        }

        private var path: String {
            switch self {
                case .searchLocation:
                    return "/search.ashx"
                case .fetchWeather:
                    return "/weather.ashx"
            }
        }

        private var params: [QueryKey: String] {
            switch self {
                case .searchLocation(let location):
                    var params: [QueryKey: String] = Api.sharedQuery
                    params[.searchString] = location.replacingOccurrences(of: " ", with: "+")
                    return params
                case .fetchWeather(let location):
                    var params: [QueryKey: String] = Api.sharedQuery
                    params[.searchString] = location.replacingOccurrences(of: " ", with: "+")
                    let weatherParams: [QueryKey: String] = [
                        .comments: QueryValue.comments,
                        .numOfDays: QueryValue.numOfDays,
                        .forcast: QueryValue.forcast,
                        .currentCondition: QueryValue.currentCondition,
                        .monthlyCondition: QueryValue.monthlyCondition,
                        .location: QueryValue.location,
                        .tp: QueryValue.tp,
                    ]

                    params.merge(weatherParams) { current, _ in current }
                    return params
            }
        }

        var urlRequest: URLRequest {
            switch self {
                case .searchLocation, .fetchWeather:
                    guard let url = baseURL.appendingPathComponent(path).appendingParams(params: params) else { fatalError("Failed to construct url") }
                    return URLRequest(url: url)
            }
        }
        
        static let apiUrl = URL(string: "https://api.worldweatheronline.com/premium/v1")!
        static let apiKey = "a8ccc099a1e34e588ed83514241206"

        enum QueryKey: String {
            case apiKey = "key"
            case searchString = "q"
            case format = "format"

            // Weather Query
            case numOfDays = "num_of_days"
            case forcast = "fx"
            case currentCondition = "cc"
            case monthlyCondition = "mca"
            case location = "includelocation"
            case comments = "show_comments"
            case tp = "tp"
        }

        enum QueryValue {
            static let numOfDays = "7"
            static let forcast = "yes"
            static let currentCondition = "yes"
            static let monthlyCondition = "no"
            static let location = "no"
            static let comments = "no"
            static let tp = "1"
        }
    }
}
