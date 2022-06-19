//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import Foundation

struct Forecast: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [CurrentWeather]
    let city: City
}

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
