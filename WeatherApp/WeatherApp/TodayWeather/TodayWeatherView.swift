//
//  ViewController.swift
//  WeatherApp
//
//  Created by Valya on 8.06.22.
//

import UIKit

protocol CurrentWeatherView: AnyObject {
    func updateViewWithCurrentWeather(_ weather: CurrentWeather)
    func updateNetworkStatus(_ message: String)
}

final class TodayWeatherView: UIViewController {
    
    lazy var topContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var centerContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tempLabel, weatherDescriptionStackView, networkStatusLabel])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var bottomContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            createItemsLineStackView(createItemStackView(feelLikeImage, createItemDescriptionStackView(feelLikeValue, feelLikeDescription)), createItemStackView(hummidityImage, createItemDescriptionStackView(hummidityValue, hummidityDescription))),
            drawLine(),
            createItemsLineStackView(createItemStackView(precipitationImage, createItemDescriptionStackView(precipitationValue, precipitationDescription)), createItemStackView(windSpeedImage, createItemDescriptionStackView(windSpeedValue, windSpeedDescription))),
            drawLine(),
            createItemsLineStackView(createItemStackView(uvIndexImage, createItemDescriptionStackView(uvIndexValue, uvIndexDescription)), createItemStackView(dewPointImage, createItemDescriptionStackView(dewPointValue, dewPointDescription))),
            drawLine(),
            createItemsLineStackView(createItemStackView(pressureImage, createItemDescriptionStackView(pressureValue, pressureDescription)), createItemStackView(visibilityImage, createItemDescriptionStackView(visibilityValue, visibilityDescription))),
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "18°C"
        label.font = UIFont.systemFont(ofSize: 70.0)
        label.textColor = .white
        return label
    }()
    
    lazy var networkStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Last update: 09.06.2022 in 23:43"
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = .white
        return label
    }()
    
    lazy var weatherDescriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherStateImage, weatherStateDescription])
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var weatherStateImage: UIImageView = {
        guard let image = UIImage(systemName: "trash") else { return UIImageView() }
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var weatherStateDescription: UILabel = {
        let label = UILabel()
        label.text = "Clouds"
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.textColor = .white
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Minsk, Belarus"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Sun, 9 June"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .white
        return label
    }()
    
    lazy var cityImageView: UIImageView = {
        guard let image = UIImage(named: "minsk") else { return UIImageView() }
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var detailInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var blackViewWithOpacity: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.4
        return view
    }()
    
    lazy var safeArea: UILayoutGuide = view.safeAreaLayoutGuide
    
    var presenter: TodayWeatherPresenter!
    
    lazy var feelLikeValue: UILabel = createLabel(text: "18°C", size: 20.0)
    lazy var feelLikeDescription: UILabel = createLabel(text: "Feel Like", size: 13.0)
    lazy var feelLikeImage: UIImageView = createBottomItemImage(iconName: "wi-feelLcike")
    
    lazy var hummidityValue: UILabel = createLabel(text: "43%", size: 20.0)
    lazy var hummidityDescription: UILabel = createLabel(text: "Hummidity", size: 13.0)
    lazy var hummidityImage: UIImageView = createBottomItemImage(iconName: "wi-humidity")
    
    lazy var precipitationValue: UILabel = createLabel(text: "0 mm", size: 20.0)
    lazy var precipitationDescription: UILabel = createLabel(text: "Rain/Snow", size: 13.0)
    lazy var precipitationImage: UIImageView = createBottomItemImage(iconName: "wi-precipitation")
    
    lazy var windSpeedValue: UILabel = createLabel(text: "3 km/h", size: 20.0)
    lazy var windSpeedDescription: UILabel = createLabel(text: "Wind", size: 13.0)
    lazy var windSpeedImage: UIImageView = createBottomItemImage(iconName: "wi-wind")
    
    lazy var uvIndexValue: UILabel = createLabel(text: "9", size: 20.0)
    lazy var uvIndexDescription: UILabel = createLabel(text: "UVIndex", size: 13.0)
    lazy var uvIndexImage: UIImageView = createBottomItemImage(iconName: "wi-uvIndex")
    
    lazy var dewPointValue: UILabel = createLabel(text: "43%", size: 20.0)
    lazy var dewPointDescription: UILabel = createLabel(text: "DewPoint", size: 13.0)
    lazy var dewPointImage: UIImageView = createBottomItemImage(iconName: "wi-dewPoint")
    
    lazy var pressureValue: UILabel = createLabel(text: "1011 mb", size: 20.0)
    lazy var pressureDescription: UILabel = createLabel(text: "Pressure", size: 13.0)
    lazy var pressureImage: UIImageView = createBottomItemImage(iconName: "wi-pressure")
    
    lazy var visibilityValue: UILabel = createLabel(text: "8 km", size: 20.0)
    lazy var visibilityDescription: UILabel = createLabel(text: "Visibility", size: 13.0)
    lazy var visibilityImage: UIImageView = createBottomItemImage(iconName: "wi-visibility")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupConstraints() {
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        blackViewWithOpacity.translatesAutoresizingMaskIntoConstraints = false
        detailInfoView.translatesAutoresizingMaskIntoConstraints = false
        topContentStackView.translatesAutoresizingMaskIntoConstraints = false
        centerContentStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomContentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: view.topAnchor),
            cityImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            cityImageView.heightAnchor.constraint(equalTo: cityImageView.widthAnchor, multiplier: 1.3/1.0),
            detailInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailInfoView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            detailInfoView.heightAnchor.constraint(equalToConstant: 295),
            blackViewWithOpacity.topAnchor.constraint(equalTo: view.topAnchor),
            blackViewWithOpacity.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackViewWithOpacity.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackViewWithOpacity.heightAnchor.constraint(equalTo: cityImageView.heightAnchor),
            topContentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            topContentStackView.leadingAnchor.constraint(equalTo: cityImageView.leadingAnchor, constant: 30),
            topContentStackView.trailingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: -30),
            centerContentStackView.bottomAnchor.constraint(equalTo: detailInfoView.topAnchor, constant: -40),
            centerContentStackView.leadingAnchor.constraint(equalTo: cityImageView.leadingAnchor, constant: 30),
            weatherStateImage.heightAnchor.constraint(equalToConstant: 25),
            weatherStateImage.widthAnchor.constraint(equalToConstant: 25),
            bottomContentStackView.leadingAnchor.constraint(equalTo: detailInfoView.leadingAnchor, constant: 30),
            bottomContentStackView.trailingAnchor.constraint(equalTo: detailInfoView.trailingAnchor, constant: -30),
            bottomContentStackView.topAnchor.constraint(equalTo: detailInfoView.topAnchor, constant: 30),
            feelLikeImage.heightAnchor.constraint(equalToConstant: 40),
            feelLikeImage.widthAnchor.constraint(equalToConstant: 40),
            hummidityImage.heightAnchor.constraint(equalToConstant: 40),
            hummidityImage.widthAnchor.constraint(equalToConstant: 40),
            precipitationImage.heightAnchor.constraint(equalToConstant: 40),
            precipitationImage.widthAnchor.constraint(equalToConstant: 40),
            windSpeedImage.heightAnchor.constraint(equalToConstant: 40),
            windSpeedImage.widthAnchor.constraint(equalToConstant: 40),
            uvIndexImage.heightAnchor.constraint(equalToConstant: 40),
            uvIndexImage.widthAnchor.constraint(equalToConstant: 40),
            dewPointImage.heightAnchor.constraint(equalToConstant: 40),
            dewPointImage.widthAnchor.constraint(equalToConstant: 40),
            pressureImage.heightAnchor.constraint(equalToConstant: 40),
            pressureImage.widthAnchor.constraint(equalToConstant: 40),
            visibilityImage.heightAnchor.constraint(equalToConstant: 40),
            visibilityImage.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setupViews() {
        view.addSubview(cityImageView)
        view.addSubview(blackViewWithOpacity)
        view.addSubview(topContentStackView)
        view.addSubview(centerContentStackView)
        view.addSubview(detailInfoView)
        detailInfoView.addSubview(bottomContentStackView)
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)
    }
    
    private func createItemDescriptionStackView(_ upperLabel: UILabel, _ bottomLabel: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [upperLabel, bottomLabel])
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createItemStackView(_ iconView: UIImageView, _ descriptionView: UIStackView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [iconView, descriptionView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createItemsLineStackView(_ itemOne: UIStackView, _ itemTwo: UIStackView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [itemOne, itemTwo])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createLabel(text: String, size: Double) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: size)
        label.textColor = .white
        return label
    }
    
    private func createBottomItemImage(iconName: String) -> UIImageView {
        let defaultImage = UIImage(named: "wi-na")!.withTintColor(.white)
        let defaultImageView = UIImageView(image: defaultImage)
        if let image = UIImage(named: iconName)?.withTintColor(.white) {
            let imageView = UIImageView(image: image)
            return imageView
        } else {
            return defaultImageView
        }
    }
    
    private func drawLine() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor(red: 70 / 255, green: 71 / 255, blue: 72 / 255, alpha: 1.0)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([line.heightAnchor.constraint(equalToConstant: 1)])
        return line
    }

}

extension TodayWeatherView: CurrentWeatherView {
    
    func updateViewWithCurrentWeather(_ weather: CurrentWeather) {
        locationLabel.text = weather.name
        tempLabel.text = String(floor(weather.main.temp)) + "°C"
    }
    
    func updateNetworkStatus(_ message: String) {
        networkStatusLabel.text = message
    }
    
}
