//
//  MainScreenViewModel.swift
//  SkyPulse
//
//  Created by Salma on 19/05/2024.
//


import Foundation
import Combine

class MainScreenViewModel: ObservableObject {
    @Published var locationName: String = ""
    @Published var currentTemperature: Double = 0.0
    @Published var conditionText: String = ""
    @Published var maxTemperature: Double = 0.0
    @Published var minTemperature: Double = 0.0
    @Published var conditionIcon: String = ""
    @Published var humidity: Int = 0
    @Published var pressure_in: Double = 0.0
    @Published var feelslike_c: Double = 0.0
    @Published var vis_km: Double = 0.0

    
    @Published var forecastDays: [ForecastDay] = []

    private var tokens: Set<AnyCancellable> = []

    init() {
        observeCoordinateUpdates()
        observeDeniedLocationAccess()
        LocationManager.shared.requestLocationUpdates()
    }

    private func observeCoordinateUpdates() {
        LocationManager.shared.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
               
            } receiveValue: { coordinates in
                self.fetchWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
            .store(in: &tokens)
    }

    private func observeDeniedLocationAccess() {
        LocationManager.shared.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
               print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }

    private func fetchWeatherData(latitude: Double, longitude: Double) {
        NetworkManager.shared.fetchData(latitude: latitude, longitude: longitude) { (result: Result<WeatherData, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecastData):
                   // print("Successfully fetched data: \(forecastData)")
                    self.locationName = forecastData.location.name
                    self.currentTemperature = forecastData.current.temp_c
                    self.conditionText = forecastData.current.condition.text
                    self.humidity =  forecastData.current.humidity
                    self.pressure_in = forecastData.current.pressure_in
                    self.feelslike_c = forecastData.current.feelslike_c
                    self.vis_km =  forecastData.current.vis_km
                    if let forecastDay = forecastData.forecast.forecastday.first {
                        self.maxTemperature = forecastDay.day.maxtemp_c
                        self.minTemperature = forecastDay.day.mintemp_c
                        self.conditionIcon = forecastDay.day.condition.icon
                        
                    }
                    self.forecastDays = forecastData.forecast.forecastday
                    print("number of hours \(self.forecastDays[0].hour.count)")

                case .failure(let error):
                    print("Failed to fetch data: \(error)")
                }
            }
        }
    }
}



