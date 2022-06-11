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

    func getCurrentWeather(handler: @escaping (CurrentWeather) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=53.88340368211527&lon=27.44718004261057&appid=41ab2c7ac8c11be44e2daabd4f52b2cb&units=metric"
        sessionManager.request(url, method: .get, encoding: JSONEncoding.default).validate().responseDecodable(of: CurrentWeather.self) { response in
            handler(response.value!)
        }
    }
    
}
