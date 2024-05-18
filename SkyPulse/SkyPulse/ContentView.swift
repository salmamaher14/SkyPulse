import SwiftUI
import Combine



struct ContentView: View {
    @StateObject var deviceLocationService = LocationManager.shared

    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    var body: some View {
        VStack {
            Text("Latitude: \(coordinates.lat)")
                .font(.largeTitle)
            Text("Longitude: \(coordinates.lon)")
                .font(.largeTitle)
        }
        .onAppear {
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
        }
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                print("Updated coordinates: \(coordinates.latitude), \(coordinates.longitude)")
                fetchWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
            .store(in: &tokens)
    }

    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
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
                    print("Successfully fetched data: \(forecastData)")
                case .failure(let error):
                    print("Failed to fetch data: \(error)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



