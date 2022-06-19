//
//  TodayWeatherModel.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import Foundation

struct CurrentWeather: Decodable {
    let coord: Coord?
    let weather: [Weather]
    let base: String?
    let main: Main
    let visibility: Int
    let pop: Double?
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
    let dt_txt: String?
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int
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
    let sea_level: Int
    let grnd_level: Int
    let temp_kf: Double?
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct Clouds: Decodable {
    let all: Int
}

struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
    let pod: String?
}
