//
//  WeatherManager.swift
//  Clima
//
//  Created by Bedri Doğan on 21.07.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation


protocol WeatherManagerProtocol {
    func performRequest(urlString: String)
    func fetchWeather(cityName: String)
    func parseJSON(weatherData: Data)
    
}

protocol WeatherManagerDelegate {
    func updateWeatherData(weather: WeatherModel)
}

class WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=1d57f9ae64829f9d003383daca29a215&&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    private var weatherModelData: WeatherData?
    var provinceName: String?
    var conditionName: String?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: url) { (data, response, error) in
                if  error != nil {
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.updateWeatherData(weather: weather)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
           let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            self.provinceName = decodeData.name
            self.weatherModelData = decodeData
            let id = weatherModelData?.weather[0].id ?? 0
            let temp = weatherModelData?.main?.temp ?? 0.0
            
            let weather = WeatherModel(conditionId: id, cityName: provinceName ?? "", temperature: temp)
            let temperatureString = weather.temperatureString
            return weather
        } catch {
            print(error)
            return nil
        }
        
    }
        
}
