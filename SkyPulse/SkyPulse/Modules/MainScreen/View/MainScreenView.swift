//
//  MainScreenView.swift
//  SkyPulse
//
//  Created by Salma on 19/05/2024.
//



import SwiftUI
import Combine
import Kingfisher

struct MainScreenView: View {
    @StateObject private var viewModel = MainScreenViewModel()

    private var backgroundImageName: String {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 6 && hour < 18) ? "Day" : "Night"
    }

    var body: some View {
        NavigationView {
            ZStack {
                Image(backgroundImageName)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.7)
                
                VStack(spacing: 5) {
                    Text(viewModel.locationName)
                        .font(.largeTitle)
                        .padding(.top, 20)
                        .foregroundColor(backgroundImageName == "Night" ? .white : .black)
                    Text("\(viewModel.currentTemperature, specifier: "%.1f")°C")
                        .font(.title)
                        .foregroundColor(backgroundImageName == "Night" ? .white : .black)
                    Text(viewModel.conditionText)
                        .font(.title)
                        .foregroundColor(backgroundImageName == "Night" ? .white : .black)
                    HStack {
                        Text("H: \(viewModel.maxTemperature, specifier: "%.1f")°")
                        Text("L: \(viewModel.minTemperature, specifier: "%.1f")°")
                    }
                    .font(.title2)
                    .foregroundColor(backgroundImageName == "Night" ? .white : .black)
                    if !viewModel.conditionIcon.isEmpty, let url = URL(string: "https:\(viewModel.conditionIcon)") {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    Text("3-DAY FORECAST")
                        .font(.headline)
                        .padding(.top, 30)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(backgroundImageName == "Night" ? .white : .black) 
                    
                    List(viewModel.forecastDays.indices, id: \.self) { index in
                        NavigationLink(destination: DetailsScreenView(viewModel: DetailsScreenViewModel(forecastDay: viewModel.forecastDays[index]))) {
                            ForecastDayRow(forecastDay: viewModel.forecastDays[index], index: index)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 40) {
                        WeatherInfoView(title: "Visibility", value: viewModel.vis_km)
                        WeatherInfoView(title: "Humidity", value: Double(viewModel.humidity))
                        WeatherInfoView(title: "Feels Like", value: viewModel.feelslike_c)
                        WeatherInfoView(title: "Pressure", value: viewModel.pressure_in)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .foregroundColor(backgroundImageName == "Night" ? .white : .black)
            Spacer()
        }
    }
}

struct WeatherInfoView: View {
    var title: String
    var value: Double

    var formattedValue: String {
        switch title {
        case "Visibility":
            return String(format: "%.1f Km", value)
        case "Humidity":
            return String(format: "%.1f %%", value)
        case "Feels Like":
            return String(format: "%.1f °", value)
        case "Pressure":
            return String(format: "%.1f", value)
        default:
            return String(format: "%.1f", value)
        }
    }

    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.headline)
            Text(formattedValue)
        }
    }
}




