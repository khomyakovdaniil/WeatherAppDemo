//
//  ContentView.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 12.06.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView(viewModel: MainViewModel(networkManager: NetworkManager(),
                                          locationManager: LocationManager(),
                                          locationsRepository: LocationsRepository()))
    }
}


#Preview {
    ContentView()
}
