//
//  URL + appendingParams.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 13.06.2024.
//

import Foundation

extension URL {
    func appendingParams(params: [Constants.Api.QueryKey: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key.rawValue, value: element.value) }

        return components?.url
    }
}
