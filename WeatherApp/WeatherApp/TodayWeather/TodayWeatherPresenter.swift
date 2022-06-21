//
//  TodayWeatherPresenter.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import Foundation
import UIKit
import CoreLocation

protocol CurrentWeatherViewPresenter: AnyObject {
    init(view: CurrentWeatherView)
    func refreshData()
    func viewDidLoad()
    func getSunriseTime(_ currentWeather: CurrentWeather) -> String
    func getSunsetTime(_ currentWeather: CurrentWeather) -> String
    func getCurrentDate(timeStyle: DateFormatter.Style, dateStyle: DateFormatter.Style) -> String
}

final class TodayWeatherPresenter: NSObject, CurrentWeatherViewPresenter  {
    
    weak var view: CurrentWeatherView?
    private let locationManager = CLLocationManager()
    private var currentWeather: CurrentWeather?
    private var currentLocation: CurrentLocation?
    
    required init(view: CurrentWeatherView) {
        self.view = view
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func refreshData() {
        if !OpenWeatherMapAPI.shared.checkConnection() {
            self.view?.updateViewWithError(ConnectionErrors.noInternetConnection.rawValue)
        } else {
            locationManager.startUpdatingLocation()
            fetchData()
        }
    }
    
    func viewDidLoad() {
        if !OpenWeatherMapAPI.shared.checkConnection() {
            self.view?.updateViewWithError(ConnectionErrors.noInternetConnection.rawValue)
        }
    }
    
    func shareCurrentWeather() {
        let data = "The weather for now: " + (currentWeather?.main.temp.rounded().removeZero)! + "°C, " + currentWeather!.weather[0].description + ", " + "wind: " + currentWeather!.wind.speed.rounded().removeZero + " meter/second"
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
    
    func getSunriseTime(_ currentWeather: CurrentWeather) -> String {
        return convertUnixDateToString(currentWeather.sys.sunrise!, timeStyle: .short, dateStyle: .none)
    }
    
    func getSunsetTime(_ currentWeather: CurrentWeather) -> String {
        return convertUnixDateToString(currentWeather.sys.sunset!, timeStyle: .short, dateStyle: .none)
    }
    
    func getCurrentDate(timeStyle: DateFormatter.Style, dateStyle: DateFormatter.Style) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = timeStyle
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeZone = .current
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    private func convertUnixDateToString(_ unixDate: Int, timeStyle: DateFormatter.Style, dateStyle: DateFormatter.Style) -> String {
        let epochTime = TimeInterval(unixDate)
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = timeStyle
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeZone = .current
        let sunriseTime = dateFormatter.string(from: date)
        return sunriseTime
    }
    
    private func fetchData() {
        if let currentLocation = currentLocation {
            OpenWeatherMapAPI.shared.getCurrentWeather(location: currentLocation, handler: { [weak self] currentWeather, error in
                if let currentWeather = currentWeather {
                    self?.currentWeather = currentWeather
                    self?.view?.updateViewWithCurrentWeather(currentWeather)
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

extension TodayWeatherPresenter: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: locValue.latitude, longitude: locValue.longitude), preferredLocale: Locale(identifier: "en_US"), completionHandler: { [weak self] placemarks, _ in
            guard let country = placemarks?.first?.country,
                  let city = placemarks?.first?.locality else { return }
            let location = CurrentLocation(lon: locValue.longitude, lat: locValue.latitude, city: city, country: country, cityImage: UIImage(named: city))
            self!.currentLocation = location
            self!.view?.updateViewWithCurrentLocation(location)
            self!.fetchData()
        })
    }

}





