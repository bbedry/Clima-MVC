//
//  WeatherData.swift
//  Clima
//
//  Created by Bedri Doğan on 8.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    var name: String
    var main: Main?
    var weather: [Weather]
}

struct Main: Decodable {
    var temp: Double?
    var presesure: Double?
    var humidty: Double?
    var temp_main: Double?
    var temp_max: Double?

}

struct Weather: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}
