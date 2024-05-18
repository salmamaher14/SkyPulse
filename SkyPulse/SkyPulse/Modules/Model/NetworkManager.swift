//
//  NetworkManager.swift
//  SkyPulse
//
//  Created by Salma on 18/05/2024.


import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchData<WeatherData: Decodable>(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let apiKey = "01029134bd9d4b1e9e4132126241805"
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(latitude),\(longitude)&days=3&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        print("Request URL: \(urlString)") // Debug print to check URL
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            // Print the raw data received
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            } else {
                print("Failed to convert raw data to string.")
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(WeatherData.self, from: data)
                print("Decoded Data: \(decodedData)")
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}


