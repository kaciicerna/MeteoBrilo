//
//  ContentView.swift
//  MeteoApp
//
//  Created by Kateřina Černá on 06.04.2023.
//

import SwiftUI
import CoreData

struct WeatherData: Decodable {
    let data: [WeatherHourlyData]
}

struct WeatherHourlyData: Decodable, Identifiable {
    let id = UUID()
    let timestamp: Int
    let temperature_2m: Double
    let relativehumidity_2m: Double
    let windspeed_10m: Double
}

struct ContentView: View {
    @State var weatherData: [WeatherHourlyData] = []
    
    var body: some View {
        NavigationView {
            List(weatherData) { weatherHourlyData in
                VStack(alignment: .leading) {
                    Text("\(formatTimestamp(weatherHourlyData.timestamp))")
                        .font(.headline)
                    Text("Temperature: \(weatherHourlyData.temperature_2m, specifier: "%.0f") °C")
                    Text("Humidity: \(weatherHourlyData.relativehumidity_2m, specifier: "%.0f") %")
                    Text("Wind Speed: \(weatherHourlyData.windspeed_10m, specifier: "%.1f") m/s")
                }
            }
            .navigationTitle("Brilo Weather")
            .onAppear {
                fetchWeatherData()
            }
        }
    }
    
    func fetchWeatherData() {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=48.9841611&longitude=14.4727092&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        self.weatherData = decodedResponse.data
                    }
                    return
                }
            }
        }.resume()
    }
    
    func formatTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter.string(from: date)
    }
}

