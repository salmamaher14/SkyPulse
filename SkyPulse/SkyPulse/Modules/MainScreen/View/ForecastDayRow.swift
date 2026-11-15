
 /* ForecastDayRow.swift
  SkyPulse

  Created by Salma on 19/05/2024.
  */

import SwiftUI
import Kingfisher



struct ForecastDayRow: View {
    var forecastDay: ForecastDay
    var index: Int

    var dayName: String {
        if index == 0 {
            return "Today"
        } else {
            guard let forecastDate = getDate(from: forecastDay.date) else {
                return forecastDay.date
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: forecastDate)
        }
    }

    var body: some View {
       
            ZStack{
                if let url = URL(string: "https:\(forecastDay.day.condition.icon)") {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                
                HStack (spacing : 10){
                    Text(dayName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(forecastDay.day.mintemp_c, specifier: "%.1f")°")
                        .font(.subheadline)
                    Text("\(forecastDay.day.maxtemp_c, specifier: "%.1f")°")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
            .padding(.vertical,10)
 
    }

    private func getDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}




