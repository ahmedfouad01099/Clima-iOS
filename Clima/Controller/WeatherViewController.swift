//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter city name"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.featchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManageDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(
        _ weatherManage: WeatherManager,
        weather: WeatherModel
    ) {
        DispatchQueue.main.async { [self] in
            temperatureLabel.text = String(format: "%.1f", weather.temperature)
            conditionImageView.image = UIImage(
                systemName: weather.conditionName
            )

        }
    }

    func didFailWithError(error: Error) {
        print("Error: \(error)")
    }
}
