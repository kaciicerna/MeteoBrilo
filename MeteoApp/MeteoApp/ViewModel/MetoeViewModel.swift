//
//  MetoeViewModel.swift
//  MeteoApp
//
//  Created by Kateřina Černá on 06.04.2023.
//

import SwiftUI

class MeteoViewModel: ObservableObject {
    
    @Published var weatherData: [Hourly] = []
    
    func loadJSONData() {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=48.9841611&longitude=14.4727092&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m") else {
            fatalError("Invalid URL")
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    DispatchQueue.main.async {
                        self.weatherData = weather.hourly
                    }
                } catch let jsonError{
                    print("An error occurred + \(jsonError)")
                }
            }
        }.resume()
    }
}

func formatTimestamp(_ timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: Double(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, HH:mm"
    return dateFormatter.string(from: date)
}
