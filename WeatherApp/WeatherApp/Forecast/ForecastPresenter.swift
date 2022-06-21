//
//  ForecastPresenter.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import Foundation
import UIKit
import CoreLocation

protocol ForecastViewPresenter: AnyObject {
    init(view: ForecastViewer)
    func shareForecast(_ currentWeather: CurrentWeather)
    func getTitleForSection(section: Int) -> String
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(_ section: Int) -> Int
    func getArrayOfCurrentWeathers() -> [[CurrentWeather]]
    func refreshData()
}

final class ForecastPresenter: NSObject, ForecastViewPresenter {
    
    weak var view: ForecastViewer?
    private let locationManager = CLLocationManager()
    private var currentLocation: CurrentLocation?
    var forecast: Forecast?
    var forecastArray: [[CurrentWeather]] = []
    
    required init(view: ForecastViewer) {
        self.view = view
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func refreshData() {
        locationManager.startUpdatingLocation()
        fetchData()
    }
    
    func shareForecast(_ currentWeather: CurrentWeather) {
        let data = "The weather on " + currentWeather.dt_txt! + ":\n" + currentWeather.main.temp.rounded().removeZero + "°C, " + currentWeather.weather.first!.description
        let firstActivityItem = data
        let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
        ]
        activityViewController.isModalInPresentation = true
        view!.presentViewController(activityViewController)
    }
    
    func getTitleForSection(section: Int) -> String {
        let dt = forecastArray[section][0].dt
        let date = Date(timeIntervalSince1970: Double(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let title = dateFormatter.string(from: date)
        return title
    }
    
    func getNumberOfRowsInSection(_ section: Int) -> Int {
        forecastArray[section].count
    }
    
    func getNumberOfSections() -> Int {
        forecastArray.count
    }
    
    func getArrayOfCurrentWeathers() -> [[CurrentWeather]] {
        forecastArray
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
            forecastArray.append(subArrayOfElements)
        }
        daysCounter += 1
        } while daysCounter < 7
    }
    
    private func fetchData() {
        if let currentLocation = currentLocation {
            OpenWeatherMapAPI.shared.getForecast(location: currentLocation, handler: { [weak self] forecast, error in
                if let forecast = forecast {
                    self!.forecast = forecast
                    self!.fillArrayOfElements()
                    self!.view?.updateViewWithForecast(forecast)
                } else if let error = error {
                    if OpenWeatherMapAPI.shared.checkConnection() {
                        self!.view?.updateViewWithError(error.localizedDescription)
                    } else {
                        self!.view?.updateViewWithError(ConnectionErrors.noInternetConnection.rawValue)
                    }
                }
            })
        }
        locationManager.stopUpdatingLocation()
    }
    
}

extension ForecastPresenter: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: locValue.latitude, longitude: locValue.longitude), preferredLocale: Locale(identifier: "en_US"), completionHandler: { [weak self] placemarks, _ in
            guard let country = placemarks?.first?.country,
                  let city = placemarks?.first?.locality else { return }
            let location = CurrentLocation(lon: locValue.longitude, lat: locValue.latitude, city: city, country: country, cityImage: UIImage(named: city))
            self!.currentLocation = location
            self!.view?.updateCurrentLocation(location)
            self!.fetchData()
        })
    }

}
