//
//  WeatherManager.swift
//  Clima
//
//  Created by Ahmed Fouad on 30/08/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManage: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager {
    let weatherURL =
        "https://api.openweathermap.org/data/2.5/weather?appid=43964ee68778487c7cd204ebe10245b3&units=metric"

    var delegate: WeatherManagerDelegate?
    
    func featchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        preformRequest(with: urlString)
    }
    
    func featchWeather(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(long)"
        preformRequest(with: urlString)
    }

    func preformRequest(with urlString: String) {
        // 1. create a URL
        if let url = URL(string: urlString) {
            // 2. create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let weather = self.parseJson(safeData) {
                        // let weatherVC = WeatherViewController()
                        // weatherVC.didUpdateWeather(weather)
                        // instead of this we can use delegate
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                    let dataString = String(data: safeData, encoding: .utf8)
                }
            }

            // 4. Start the task
            task.resume()
        }
    }

    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(
                WeatherData.self,
                from: weatherData
            )
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name

            let weather = WeatherModel(
                conditionId: id,
                cityName: name,
                temperature: temp
            )

            print(weather)

            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
