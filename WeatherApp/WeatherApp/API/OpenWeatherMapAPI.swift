//
//  OpenWeatherMapAPI.swift
//  WeatherApp
//
//  Created by Valya on 11.06.22.
//

import Foundation
import Alamofire

enum ConnectionErrors: String {
    case noInternetConnection = "No internet connection"
    case apiConnectionError = "Error with connection to server"
}

final class OpenWeatherMapAPI {
    
    static let shared = OpenWeatherMapAPI()
    
    private init() {}
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = false
        return Session(configuration: configuration)
    }()
    
    private let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")

    func getCurrentWeather(location: CurrentLocation, handler: @escaping (CurrentWeather?, AFError?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let parameters: Parameters = [
            "lat" : location.lat,
            "lon" : location.lon,
            "appid" : "41ab2c7ac8c11be44e2daabd4f52b2cb",
            "units" : "metric"
        ]
        sessionManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseDecodable(of: CurrentWeather.self) { response in
            switch response.result {
            case .failure(let error):
                handler(nil, error)
            case .success(let currentWeather):
                handler(currentWeather, nil)
            }
        }
    }
    
    func getForecast(location: CurrentLocation, handler: @escaping (Forecast?, AFError?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/forecast"
        let parameters: Parameters = [
            "lat" : location.lat,
            "lon" : location.lon,
            "appid" : "41ab2c7ac8c11be44e2daabd4f52b2cb",
            "units" : "metric"
        ]
        sessionManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseDecodable(of: Forecast.self) { response in
            switch response.result {
            case .failure(let error):
                handler(nil, error)
            case .success(let forecast):
                handler(forecast, nil)
            }
        }
    }
    
    func checkConnection() -> Bool {
        reachabilityManager!.isReachable
    }
}

