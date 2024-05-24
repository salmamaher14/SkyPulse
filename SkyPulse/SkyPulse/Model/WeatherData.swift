//
//  LocationData.swift
//  SkyPulse
//
//  Created by Salma on 18/05/2024.
//

import Foundation

struct WeatherData :Codable {
    
    var location : Location
    var current : Current
    var forecast : Forecast
}


struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}

struct Current: Codable {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let pressure_in: Double
    let humidity: Int
    let feelslike_c: Double
    let vis_km : Double
 
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable  {
    
    let date: String
    let date_epoch: Int
    let day: Day
    let hour : [Hour]
   
}


struct Day: Codable {
    let mintemp_c: Double
    let maxtemp_f: Double
    let maxtemp_c: Double
    let mintemp_f: Double
    let condition: Condition
}

struct Hour: Codable {
 
    let time: String
    let temp_c: Double
    let condition: Condition

}









