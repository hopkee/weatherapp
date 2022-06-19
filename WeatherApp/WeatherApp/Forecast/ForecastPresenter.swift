//
//  ForecastPresenter.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import Foundation

protocol ForecastViewPresenter: AnyObject {
    init(view: ForecastViewer)
    func viewDidLoad()
    func shareForecast()
    func getTitleForSection(section: Int) -> String
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(_ section: Int) -> Int
    func getArrayOfCurrentWeathers() -> [[CurrentWeather]]
}

final class ForecastPresenter: NSObject, ForecastViewPresenter {
    
    weak var view: ForecastViewer?
    var currentLocation: Coord = Coord(lon: 27.44718004261057, lat: 53.88340368211527)
    var forecast: Forecast?
    var arrayOfElements: [[CurrentWeather]] = []
    
    required init(view: ForecastViewer) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchData()
    }
    
    func shareForecast() {
        //TODO: Share function
    }
    
    func getTitleForSection(section: Int) -> String {
        let dt = arrayOfElements[section][0].dt
        let date = Date(timeIntervalSince1970: Double(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let title = dateFormatter.string(from: date)
        return title
    }
    
    func getNumberOfRowsInSection(_ section: Int) -> Int {
        arrayOfElements[section].count
    }
    
    func getNumberOfSections() -> Int {
        arrayOfElements.count
    }
    
    func getArrayOfCurrentWeathers() -> [[CurrentWeather]] {
        arrayOfElements
    }
    
    private func fillArrayOfElements() {
        var daysCounter = 0
        let today = Date()
        repeat {
        let date = Calendar.current.date(byAdding: .day, value: daysCounter, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let dateForComparison = dateFormatter.string(from: date)
        var subArrayOfElements: [CurrentWeather] = []
        for element in forecast!.list {
            if element.dt_txt!.contains(dateForComparison) {
                subArrayOfElements.append(element)
            }
        }
        if !subArrayOfElements.isEmpty {
            arrayOfElements.append(subArrayOfElements)
        }
        daysCounter += 1
        } while (daysCounter < 7)
    }
    
    private func fetchData() {
        OpenWeatherMapAPI.shared.getForecast(location: currentLocation, handler: { [weak self] forecast in
            self!.forecast = forecast
            self!.fillArrayOfElements()
            self!.view?.updateViewWithForecast(forecast)
        })
    }
    
}
