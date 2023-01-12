    //
    //  ContentView.swift
    //  Weather-App
    //
    //  Created by Thiago de Bastos on 12/1/2023.
    //

import SwiftUI

struct DailyWeatherView: View {
    var weather: Weather
    @Binding var isNight: Bool

    var body: some View {
        HStack {
            VStack() {
                Text(weather.dayOfWeek)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.white)

                Image(systemName: isNight ? weather.imageNameNight : weather.imageNameDay)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)

                Text("\(weather.temperature)°")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

let date = Date()
var calendar = Calendar.current
let hour = calendar.component(.hour, from : date)

struct ContentView: View {
    @State private var isNight = !(hour > 5 && hour < 16)

    var body: some View {

        ZStack {

            BackgroundView(
                topColor: isNight ? .black : .blue,
                bottomColor: isNight ? Color("darkBlue") : Color("lightBlue")
            )

            VStack {

                CityTextView(cityName: "Sydney, NSW")

                MainWeatherStatusView(temperature: 25, imageName: isNight ? "cloud.moon.fill" : "cloud.sun.fill")

                Spacer()

                WeekForecastView(forecastList: dailyWeatherResults, isNight: $isNight)

                Spacer()

                Button {
                    isNight.toggle()
                } label: {
                    WeatherButton(
                        title: "Change Day Time",
                        textColor: .blue,
                        backgroundColor: .white
                    )
                }

                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BackgroundView: View {

    var topColor: Color
    var bottomColor: Color

    var body: some View {
        LinearGradient(gradient: Gradient(colors:  [topColor, bottomColor]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {

    var cityName: String

    var body: some View {

        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {

    var temperature: Int
    var imageName: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)

            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
    }
}



struct Weather {
    var dayOfWeek: String
    var temperature: Int
    var imageNameDay: String
    var imageNameNight: String
}

var dailyWeatherResults: [Weather]  = [
    Weather(dayOfWeek: "TUE", temperature: 23, imageNameDay: "cloud.sun.fill",  imageNameNight: "cloud.moon.fill"),
    Weather(dayOfWeek: "WED", temperature: 21, imageNameDay: "cloud.fill",  imageNameNight: "cloud.fill"),
    Weather(dayOfWeek: "THU", temperature: 28, imageNameDay: "sun.max.fill",  imageNameNight: "moon.fill"),
    Weather(dayOfWeek: "FRI", temperature: 18, imageNameDay: "wind",  imageNameNight: "wind"),
    Weather(dayOfWeek: "SAT", temperature: 16, imageNameDay: "cloud.sun.rain.fill",  imageNameNight: "cloud.moon.rain.fill"),
    Weather(dayOfWeek: "SUN", temperature: 5,  imageNameDay: "cloud.snow.fill",  imageNameNight: "cloud.snow.fill")
]

struct WeekForecastView: View {
    var forecastList: [Weather]
    @Binding var isNight: Bool

    var body: some View {
        HStack(spacing: 14) {
            ForEach(forecastList, id: \.self.dayOfWeek) { weather in
                DailyWeatherView(weather: weather, isNight: $isNight)
            }
        }
    }
}
