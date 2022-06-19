//
//  TodayWeatherPresenter.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import Foundation
import CoreLocation
import UIKit

protocol CurrentWeatherViewPresenter: AnyObject {
    init(view: CurrentWeatherView)
    func viewDidLoad()
    func refreshData()
    func getSunriseTime(_ currentWeather: CurrentWeather) -> String
    func getSunsetTime(_ currentWeather: CurrentWeather) -> String
    func getLastUpdateTime(_ currentWeather: CurrentWeather) -> String
    func getCurrentDate() -> String
}

final class TodayWeatherPresenter: NSObject, CurrentWeatherViewPresenter  {
    
    weak var view: CurrentWeatherView?
    private var currentWeather: CurrentWeather?
    private var currentLocation: Coord?
    private let locationManager = CLLocationManager()
    
    required init(view: CurrentWeatherView) {
        self.view = view
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func viewDidLoad() {
        fetchData()
    }
    
    func refreshData() {
        fetchData()
    }
    
    func shareCurrenrtWeather() {
        let data = "The weather for now: " + (currentWeather?.main.temp.rounded().removeZero)! + "°C, " + currentWeather!.weather[0].description + ", " + "wind: " + (currentWeather?.wind.speed.rounded().removeZero)! + " meter/second"
        let firstActivityItem = data
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)
        activityViewController.activityItemsConfiguration = [
        UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
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
    
    func getLastUpdateTime(_ currentWeather: CurrentWeather) -> String {
        convertUnixDateToString(currentWeather.dt, timeStyle: .short, dateStyle: .medium)
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = .current
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    private func convertUnixDateToString(_ unixDate: Int, timeStyle: DateFormatter.Style, dateStyle: DateFormatter.Style) -> String {
        let date = Date(timeIntervalSince1970: Double(unixDate))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = timeStyle
            dateFormatter.dateStyle = dateStyle
            dateFormatter.timeZone = .current
            let sunriseTime = dateFormatter.string(from: date)
            return sunriseTime
    }
    
    private func fetchData() {
        if let currentLocation = currentLocation {
            OpenWeatherMapAPI.shared.getCurrentWeather(location: currentLocation, handler: { [weak self] currentWeather in
                self?.view?.updateViewWithCurrentWeather(currentWeather)
                self?.currentWeather = currentWeather
            })
        }
    }
    
}

extension TodayWeatherPresenter: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let location = Coord(lon: locValue.longitude, lat: locValue.latitude)
        currentLocation = location
    }
    
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}



