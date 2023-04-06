//
//  MeteoViewList.swift
//  MeteoApp
//
//  Created by Kateřina Černá on 06.04.2023.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MeteoListView: View {
    
    @StateObject var viewModel = MeteoViewModel()
       
       var body: some View {
           List {
               ForEach(viewModel.weatherData, id: \.time.first) { hourlyData in
                   Section(header: Text(formatTimestamp(Int(hourlyData.time.first!)!))) {
                       ForEach(hourlyData.time.indices, id: \.self) { index in
                           HStack {
                               Text(formatTimestamp(Int(hourlyData.time[index])!))
                               Spacer()
                               Text("\(Int(hourlyData.temperature2M[index]))°C")
                               Text("\(hourlyData.relativehumidity2M[index])%")
                               Text("\(Int(hourlyData.windspeed10M[index])) km/h")
                           }
                       }
                   }
               }
           }
           .onAppear {
               viewModel.loadJSONData()
           }
       }
}

