
import SwiftUI
import Kingfisher

struct DetailsScreenView: View {
    @StateObject var viewModel: DetailsScreenViewModel
    private var backgroundImageName: String {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 6 && hour < 18) ? "Day" : "Night"
    }

    var body: some View {
        ZStack {
            Image(backgroundImageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.7)

            VStack(alignment: .leading) {
                List {
                    ForEach(filteredHourlyWeather(), id: \.time) { hour in
                        HStack {
                            Text(isCurrentHour(hour) ? "Now" : getFormattedHour(from: hour.time))
                                .font(.headline)
                                .foregroundColor(backgroundImageName == "Night" ? .white : .black)

                            Spacer()

                            if let url = URL(string: "https:\(hour.condition.icon)") {
                                KFImage(url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                            }

                            Spacer()

                            Text("\(hour.temp_c, specifier: "%.1f")°")
                                .font(.subheadline)
                                .foregroundColor(backgroundImageName == "Night" ? .white : .black)
                        }
                        .padding(.vertical)
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                        .listRowBackground(Color.clear)
                        .id(hour.time)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding(.top , 70)
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









