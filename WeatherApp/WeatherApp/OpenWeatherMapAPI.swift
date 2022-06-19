//
//  OpenWeatherMapAPI.swift
//  WeatherApp
//
//  Created by Valya on 11.06.22.
//

import Foundation
import Alamofire

final class OpenWeatherMapAPI {
    
    static let shared = OpenWeatherMapAPI()
    
    private init() {}
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30
        return Session(configuration: configuration)
    }()

    func getCurrentWeather(location: Coord, handler: @escaping (CurrentWeather) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let parameters: Parameters = [
            "lat" : location.lat,
            "lon" : location.lon,
            "appid" : "41ab2c7ac8c11be44e2daabd4f52b2cb",
            "units" : "metric"
        ]
        sessionManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseDecodable(of: CurrentWeather.self) { response in
            handler(response.value!)
        }
    }
    
    func getForecast(location: Coord, handler: @escaping (Forecast) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/forecast"
        let parameters: Parameters = [
            "lat" : location.lat,
            "lon" : location.lon,
            "appid" : "41ab2c7ac8c11be44e2daabd4f52b2cb",
            "units" : "metric"
        ]
        sessionManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseDecodable(of: Forecast.self) { response in
            handler(response.value!)
        }
    }
    
}
