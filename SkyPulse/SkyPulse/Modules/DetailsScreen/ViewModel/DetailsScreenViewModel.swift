//
//  DetailsScreenViewModel.swift
//  SkyPulse
//
//  Created by Salma on 20/05/2024.
//

import Foundation

import Combine

class DetailsScreenViewModel: ObservableObject {
    @Published var hourlyWeather: [Hour] = []
     var forecastDay: ForecastDay

    
    private var tokens: Set<AnyCancellable> = []

    
    init(forecastDay: ForecastDay) {
        self.forecastDay = forecastDay
        print("forcastday \(forecastDay.hour.count)")
        hourlyWeather = forecastDay.hour

    }

  
}
