//
//  MainView.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 12.06.2024.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: MainViewModel
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack {
            TextField(Constants.Strings.searchBarPrompt, text: $viewModel.searchText)
                .focused($showKeyboard)
                .padding()
                .background(Color(.secondarySystemBackground))
                .padding()
            ZStack {
                VStack {
                    Text(viewModel.selectedPlace)
                        .font(.title)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    HStack {
                        Text(viewModel.currentWeather?.tempFormatted ?? Constants.Strings.noData)
                            .fontWeight(.semibold)
                    }.font(.system(size: 54))
                        .frame(maxWidth: .infinity)
                    Text((viewModel.currentWeather?.weatherDescription ?? Constants.Strings.noData) + ", humidity: " +  (viewModel.currentWeather?.humidityFormatted ?? Constants.Strings.noData))
                        .foregroundColor(.secondary)
                    Button(action: {
                        viewModel.saveCurrentLocation()
                    }, label: { Text(Constants.Strings.saveLocation)})
                    .padding()
                    .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Text(Constants.Strings.hourlyForecastHeader)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(viewModel.forecast.first?.hourly ?? []) { hourlyWeather in
                                VStack {
                                    Text(hourlyWeather.tempFormatted)
                                    Text(hourlyWeather.timeFormatted)
                                }
                                .padding(4)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.leading)
                    Text(Constants.Strings.weeklyForecastHeader)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(viewModel.forecast.dropFirst()) { weather in
                                VStack {
                                    Text("\(weather.highTempFormatted) / \(weather.lowTempFormatted)")
                                    Text(weather.day)
                                }
                                .padding(.horizontal, 4)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                
                            }
                        }
                    }
                    .padding(.leading)
                    List(selection: $viewModel.defaultLocation) {
                        ForEach(viewModel.locations, id: \.self) { location in
                            Label(location,
                                  systemImage: viewModel.defaultLocation == location ? "checkmark" : "circle")
                        }
                        .onDelete(perform: { indexSet in
                            viewModel.removeLocation(at: indexSet)
                        })
                    }
                }
                if !viewModel.searchResults.isEmpty {
                    List(viewModel.searchResults, id: \.self) { place in
                        HStack {
                            Button(place) {
                                viewModel.selectedPlace = place
                                showKeyboard = false
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                } 
            }
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel(networkManager: NetworkManager(),
                                      locationManager: LocationManager(),
                                      locationsRepository: LocationsRepository()))
}
