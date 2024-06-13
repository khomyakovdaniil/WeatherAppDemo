//
//  ServerError.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 12.06.2024.
//

import Foundation

enum ServerError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
}

extension ServerError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Failed to decode the object from the service"
            case .errorCode(let code):
                return "\(code) - error code from API"
            case .unknown:
                return "Unkwown error"
        }
    }
}
