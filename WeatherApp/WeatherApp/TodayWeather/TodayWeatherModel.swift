//
//  TodayWeatherModel.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import Foundation
import UIKit

struct CurrentWeather: Decodable {
    let coord: Coord?
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys
    let dt_txt: String?
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct Rain: Decodable {
    let oneHour: Double?
    let threeHours: Double?
    
    private enum CodingKeys : String, CodingKey {
            case oneHour = "1h"
            case threeHours = "3h"
    }
}

struct Snow: Decodable {
    let oneHour: Double?
    let threeHours: Double?
    
    private enum CodingKeys : String, CodingKey {
            case oneHour = "1h"
            case threeHours = "3h"
    }
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let temp_kf: Double?
}

struct Wind: Decodable {
    let speed: Double
}

struct Sys: Decodable {
    let sunrise: Int?
    let sunset: Int?
    let pod: String?
}

struct CurrentLocation {
    let lon: Double
    let lat: Double
    let city: String
    let country: String
    let cityImage: UIImage?
}
