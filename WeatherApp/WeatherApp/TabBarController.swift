//
//  TabBarConttroller.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupUI()
    }
    
    private func setupViewControllers() {
        // Initializing view and setup presenter for today weather screen
        let todayWeatherView = TodayWeatherView()
        let todayWeatherPresenter = TodayWeatherPresenter(view: todayWeatherView)
        todayWeatherView.presenter = todayWeatherPresenter
        
        // Initializing view and setup presenter for forecast weather screen
        let forecastView = ForecastView()
        let forecastPresenter = ForecastPresenter(view: forecastView)
        forecastView.presenter = forecastPresenter
        
        viewControllers = [
            createNavigationController(todayWeatherView, "Today", UIImage(named: "tb-today")!),
            createNavigationController(forecastView, "Forecast", UIImage(named: "tb-forecast")!)
        ]
    }
    
    private func createNavigationController(_ rootVC: UIViewController,
                                            _ title: String,
                                            _ image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image.withTintColor(.white)
        rootVC.navigationItem.title = title
        return navigationController
    }
    
    private func setupUI() {
        let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for:.selected)
        UITabBar.appearance().tintColor = .white
        view.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)
    }

}
