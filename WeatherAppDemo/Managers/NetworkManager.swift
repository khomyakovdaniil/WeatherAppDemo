//
//  NetworkManager.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 12.06.2024.
//

import Foundation

import Combine
import Foundation

final class NetworkManager {
    
    let session: URLSession

    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }

    func fetchWeather(location: String) -> AnyPublisher<WeatherData, ServerError> {
        let endpoint = Constants.Api.fetchWeather(location: location)

        return session
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                ServerError.errorCode(error.errorCode)
            }
            .flatMap { data, response -> AnyPublisher<WeatherData, ServerError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: ServerError.unknown).eraseToAnyPublisher()
                }
                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    return Just(data)
                        .decode(type: WeatherResponse.self, decoder: jsonDecoder)
                        .mapError { _ in
                            return ServerError.decodingError
                        }
                        .map { $0.data }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: ServerError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    func searchLocation(location: String) -> AnyPublisher<[Place], ServerError> {
        let endpoint = Constants.Api.searchLocation(location: location)

        return session
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                ServerError.errorCode(error.errorCode)
            }
            .flatMap { data, response -> AnyPublisher<[Place], ServerError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: ServerError.unknown).eraseToAnyPublisher()
                }
                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    return Just(data)
                        .decode(type: LocationResponse.self, decoder: jsonDecoder)
                        .mapError { error in
                            return ServerError.decodingError
                        }
                        .map { $0.searchAPI.result }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: ServerError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
