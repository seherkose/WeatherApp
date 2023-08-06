//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Seher Köse on 4.08.2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b80810bded388ab99e7de4ac7c7f85a0&units=metric"
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
        //print(urlString)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    

        
    func performRequest(urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            //grab all data
            // use closure in completion handler
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //print(error!)
                    return //exit
                }
                
                if let safeData = data{
                    /*let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString)*/
                    //WeatherModel'dan weather nesnesini oluşturduktan sonra onu parseJSON kodladığımız yere return ediyoruz.
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            //can throw error
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
            print(decodedData.weather[0].id)
            print(decodedData.sys.country)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city_name = decodedData.name
            let country = decodedData.sys.country
            
            let weather = WeatherModel(conditionId: id, cityName: city_name, temperature: temp, sys: country)
            
            print(weather.conditionName)
            print(weather.temperatureString)
            return weather
          //does throw an error
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
        
    }

    
}

























