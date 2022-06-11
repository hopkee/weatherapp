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
        
        viewControllers = [
            createNavigationController(todayWeatherView, "Today", UIImage(named: "tb-today")!),
            createNavigationController(ForecastView(), "Forecast", UIImage(named: "tb-forecast")!)
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
        UITabBar.appearance().barTintColor = .systemBackground
        view.backgroundColor = .systemBackground
    }

}
