//
//  MainViewModel.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 12.06.2024.
//

import Combine
import SwiftUI
import CoreLocation

class MainViewModel: ObservableObject {
    
    private let networkManager: NetworkManager
    private let locationManager: LocationManager
    private let locationsRepository: LocationsRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public properties
    @Published private(set) var currentWeather: CurrentWeather?
    @Published private(set) var forecast: [WeatherElement] = []
    @Published var searchText: String = ""
    @Published private(set) var searchResults = [String]()
    @Published var locations: [String] = []
    
    var selectedPlace: String {
        didSet {
            fetchWeather()
            searchText = ""
            searchResults = []
        }
    }
    
    @AppStorage("default")
    var defaultLocation: String? {
        didSet {
            guard let defaultLocation else {
                return
            }
            selectedPlace = defaultLocation
        }
    }
    
    init(networkManager: NetworkManager, locationManager: LocationManager, locationsRepository: LocationsRepository) {
        self.networkManager = networkManager
        self.locationsRepository = locationsRepository // TODO: Create
        self.locationManager = locationManager
        selectedPlace = ""
        $searchText
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: searchForPlaces(forLocation:))
            .store(in: &cancellables)
        locationsRepository.load()
        locationsRepository.$locations
            .sink { [weak self] locations in
                self?.locations = locations
            }
            .store(in: &cancellables)
        locationManager.$currentLocation
            .sink { [weak self] _ in
                if self?.selectedPlace == Constants.Strings.currentLocation {
                    self?.fetchWeather()
                }
            }
            .store(in: &cancellables)
        selectedPlace = defaultLocation ?? Constants.Strings.currentLocation
        fetchWeather()
    }
    
    func fetchWeather() {
        if selectedPlace == Constants.Strings.currentLocation {
            guard let location = locationManager.currentLocation else {
                return
            }
            fetchWeather(for: location)
        } else {
            fetchWeather(for: selectedPlace)
        }
    }
    
    
    private func searchForPlaces(forLocation location: String) {
        guard location.count > 1 else { return }
        searchResults = []
        networkManager.searchLocation(location: location)
            .sink { operationResult in
                switch operationResult {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    break
                }
            } receiveValue: { [weak self] places in
                self?.searchResults = places.map({$0.fullString})
            }
            .store(in: &cancellables)
    }
    
    private func fetchWeather(for location: String) {
        networkManager.fetchWeather(location: location)
            .sink { operationResult in
                switch operationResult {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    break
                }
            } receiveValue: { [weak self] weather in
                self?.currentWeather = weather.currentWeather.first
                self?.forecast = weather.dailyWeather
            }
            .store(in: &cancellables)
    }
    
    func saveCurrentLocation() {
        locationsRepository.saveLocation(selectedPlace)
    }
    
    func removeLocation(at index: IndexSet) {
        locations.remove(atOffsets: index)
        locationsRepository.saveLocations(locations)
    }
    
}
