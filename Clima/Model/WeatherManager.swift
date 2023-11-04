//
//  WeatherManager.swift
//  Clima
//
//  Created by David C Santander on 03/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&APPID=a37aad33ce976963ad11db3e190a6eb2"
    
    
    func fetchWeatherCity(cityName: String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        perfomeRequest(urlString: urlString)
    }
    
    func perfomeRequest(urlString: String) {
        if let url = URL(string: urlString){
            let sesion = URLSession(configuration: .default)
            
            let task = sesion.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            task.resume()
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
