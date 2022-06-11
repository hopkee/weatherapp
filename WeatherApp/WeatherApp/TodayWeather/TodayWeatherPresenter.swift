//
//  TodayWeatherPresenter.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import Foundation

protocol CurrentWeatherViewPresenter: AnyObject {
    init(view: CurrentWeatherView)
    func viewDidLoad()
    func refreshData()
}

class TodayWeatherPresenter: CurrentWeatherViewPresenter {
    
    weak var view: CurrentWeatherView?
    private var currentWeather: CurrentWeather?
    
    required init(view: CurrentWeatherView) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchData()
    }
    
    func refreshData() {
        fetchData()
    }
    
    private func fetchData() {
        OpenWeatherMapAPI.shared.getCurrentWeather(handler: { currentWeather in
            self.view?.updateViewWithCurrentWeather(currentWeather)
            self.currentWeather = currentWeather
        })
    }
    
    
}
