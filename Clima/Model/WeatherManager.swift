//
//  WeatherManager.swift
//  Clima
//
//  Created by David C Santander on 03/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation


protocol WeatherDelegate{
    func didUpdateWeather(_ weather: WeatherModel)
}


struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&APPID=a37aad33ce976963ad11db3e190a6eb2"
    
    var delegate: WeatherDelegate?
    
    
    func fetchWeatherCity(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        perfomeRequest(urlString: urlString)
    }
    
    func perfomeRequest(urlString: String) {
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        delegate?.didUpdateWeather(weather)
                    }
                }
            }
            //let task = sesion.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let cityName = decodedData.name
            let weatherDescription = decodedData.weather[0].description
            let weather = WeatherModel(weatherConditionId: id, cityName: cityName, description: weatherDescription, temperature: temperature)
            return weather;
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString ??  "")
        }
    }
}
