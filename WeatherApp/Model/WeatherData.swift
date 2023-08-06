//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Seher Köse on 5.08.2023.
//

import Foundation
struct WeatherData: Codable{
    let name: String
    let main: Main
    //weather property holds array with 1 item
    let weather: [Weather]
    let sys: SYS
    
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let description: String
    let id: Int
}

struct SYS: Codable{
    let country: String
}


