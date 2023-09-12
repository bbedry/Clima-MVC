//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.weatherManager.delegate = self
        searchTextField.delegate = self
        if #available(iOS 14.0, *) {
            locationManager.delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        requestLocationAllows()
    }
    
    private func requestLocationAllows() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
     }

    @IBAction func searchCityName(_ sender: UITextField) {
        
    }
    @IBAction func tappedCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            
            textField.layer.borderColor = UIColor.red.cgColor
            return false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    func updateWeatherData(weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
        }
     
    }
    
    func errorWithDidFailure(error: Error) {
        print(error)
    }
    
    
}


@available(iOS 14.0, *)
extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("error:: \(error.localizedDescription)")
      }

      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          
          if let locations = locations.last {
              locationManager.stopUpdatingLocation()
              let latitude = locations.coordinate.latitude
              let longtitude = locations.coordinate.longitude
              
              weatherManager.fetchUserLocation(lat: latitude, long: longtitude)
          }
      }
    
}
