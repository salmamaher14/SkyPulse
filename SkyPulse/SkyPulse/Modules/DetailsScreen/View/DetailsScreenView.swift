
import SwiftUI
import Kingfisher



struct DetailsScreenView: View {
    @StateObject var viewModel: DetailsScreenViewModel

    private var isNight: Bool { backgroundImageName == "night_background" }
    private var textColor: Color { isNight ? .white : .black }

    private var backgroundImageName: String {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 6 && hour < 18) ? "Day" : "night_background"
    }

    var body: some View {
        ZStack {
            Image(backgroundImageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.7)

          
                List{
                    ForEach(filteredHourlyWeather(), id: \.time) { hour in
                        ZStack {
                            if let url = URL(string: "https:\(hour.condition.icon)") {
                                KFImage(url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                            }

                            HStack {
                                Text(isCurrentHour(hour) ? "Now" : getFormattedHour(from: hour.time))
                                    .font(.headline)
                                    .lineLimit(1)
                                    .foregroundColor(textColor)

                                Spacer()

                                Text("\(hour.temp_c, specifier: "%.1f")°")
                                    .font(.subheadline)
                                    .monospacedDigit()
                                    .foregroundColor(textColor)
                            }.frame(height: 40)
                        }
                        .padding(.horizontal)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(textColor.opacity(0.3))
                        .id(hour.time)
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .safeAreaPadding()
                .padding(.horizontal)
                .padding(.top, 70)
                .padding(.bottom, 16)
 
        }
}


    private func filteredHourlyWeather() -> [Hour] {
        let currentHourString = getCurrentHour()
        return viewModel.hourlyWeather.filter { $0.time >= currentHourString }
    }

    private func getCurrentHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:00"
        return dateFormatter.string(from: Date())
    }

    private func isCurrentHour(_ hour: Hour) -> Bool {
        return hour.time == getCurrentHour()
    }

    private func getFormattedHour(from dateTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = dateFormatter.date(from: dateTime) else {
            return dateTime
        }
        dateFormatter.dateFormat = "ha"
        return dateFormatter.string(from: date)
    }
}

