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
    func presentViewController(_ controller: UIViewController)
}

final class TodayWeatherView: UIViewController {
    
    lazy var topContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var centerContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tempLabel, weatherDescriptionStackView, networkStatusStackView])
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
            createItemsLineStackView(createItemStackView(sunriseImage, createItemDescriptionStackView(sunriseValue, sunriseDescription)), createItemStackView(sunsetImage, createItemDescriptionStackView(sunsetPointValue, sunsetDescription))),
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
        label.text = "-°C"
        label.font = UIFont.systemFont(ofSize: 70.0)
        label.textColor = .white
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        let shareImage = UIImage(systemName: "square.and.arrow.up")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(shareImage, for: .normal)
        button.addTarget(self, action: #selector(shareWeather), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var networkStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading data..."
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
    
    lazy var networkStatusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [networkStatusButton, shareButton])
        stackView.axis = .horizontal
        stackView.spacing = 50
        return stackView
    }()
    
    lazy var weatherStateImage: UIImageView = {
        guard let image = UIImage(named: "wi-na")?.withTintColor(.white) else { return UIImageView() }
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var weatherStateDescription: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.textColor = .white
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .white
        return label
    }()
    
    lazy var networkStatusButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
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
        view.layer.opacity = 0.5
        return view
    }()
    
    lazy var safeArea: UILayoutGuide = view.safeAreaLayoutGuide
    
    var presenter: TodayWeatherPresenter!
    
    lazy var feelLikeValue: UILabel = createLabel(text: "-", size: 20.0)
    lazy var feelLikeDescription: UILabel = createLabel(text: "Feel Like", size: 13.0)
    lazy var feelLikeImage: UIImageView = createBottomItemImage(iconName: "wi-feelLike")
    
    lazy var hummidityValue: UILabel = createLabel(text: "-", size: 20.0)
    lazy var hummidityDescription: UILabel = createLabel(text: "Hummidity", size: 13.0)
    lazy var hummidityImage: UIImageView = createBottomItemImage(iconName: "wi-humidity")
    
    lazy var precipitationValue: UILabel = createLabel(text: "-", size: 20.0)
    lazy var precipitationDescription: UILabel = createLabel(text: "Rain/Snow", size: 13.0)
    lazy var precipitationImage: UIImageView = createBottomItemImage(iconName: "wi-precipitation")
    
    lazy var windSpeedValue: UILabel = createLabel(text: "-", size: 20.0)
    lazy var windSpeedDescription: UILabel = createLabel(text: "Wind", size: 13.0)
    lazy var windSpeedImage: UIImageView = createBottomItemImage(iconName: "wi-wind")
    
    lazy var sunriseValue: UILabel = createLabel(text: "-", size: 20.0)
    lazy var sunriseDescription: UILabel = createLabel(text: "Sunrise", size: 13.0)
    lazy var sunriseImage: UIImageView = createBottomItemImage(iconName: "wi-sunrise")
    
    lazy var sunsetPointValue: UILabel = createLabel(text: "-", size: 20.0)
    lazy var sunsetDescription: UILabel = createLabel(text: "Sunset", size: 13.0)
    lazy var sunsetImage: UIImageView = createBottomItemImage(iconName: "wi-sunset")
    
    lazy var pressureValue: UILabel = createLabel(text: "-", size: 20.0)
    lazy var pressureDescription: UILabel = createLabel(text: "Pressure", size: 13.0)
    lazy var pressureImage: UIImageView = createBottomItemImage(iconName: "wi-pressure")
    
    lazy var visibilityValue: UILabel = createLabel(text: "-", size: 20.0)
    lazy var visibilityDescription: UILabel = createLabel(text: "Visibility", size: 13.0)
    lazy var visibilityImage: UIImageView = createBottomItemImage(iconName: "wi-visibility")
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
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
            centerContentStackView.trailingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: -30),
            weatherStateImage.heightAnchor.constraint(equalToConstant: 40),
            weatherStateImage.widthAnchor.constraint(equalToConstant: 40),
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
            sunriseImage.heightAnchor.constraint(equalToConstant: 40),
            sunriseImage.widthAnchor.constraint(equalToConstant: 40),
            sunsetImage.heightAnchor.constraint(equalToConstant: 40),
            sunsetImage.widthAnchor.constraint(equalToConstant: 40),
            pressureImage.heightAnchor.constraint(equalToConstant: 40),
            pressureImage.widthAnchor.constraint(equalToConstant: 40),
            visibilityImage.heightAnchor.constraint(equalToConstant: 40),
            visibilityImage.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc func refreshData() {
        presenter.refreshData()
    }
    
    @objc func shareWeather() {
        print("Share weather")
        presenter.shareCurrenrtWeather()
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
        dateLabel.text = presenter.getCurrentDate()
        locationLabel.text = weather.name
        tempLabel.text = weather.main.temp.rounded().removeZero + "°C"
        weatherStateImage.image = UIImage(named: weather.weather[0].icon)?.withTintColor(.white)
        weatherStateDescription.text = weather.weather[0].main
        networkStatusButton.setTitle("Last update: " + presenter.getLastUpdateTime(weather), for: .normal)
        feelLikeValue.text = weather.main.feels_like.rounded().removeZero + "°C"
        hummidityValue.text = String(weather.main.humidity) + "%"
        precipitationValue.text = (weather.rain?.oneHour?.description ??
                                   weather.rain?.threeHours?.description ??
                                   weather.snow?.oneHour?.description ??
                                   weather.snow?.threeHours?.description ?? "0") + " mm"
        windSpeedValue.text = weather.wind.speed.rounded().removeZero + " meter/sec"
        sunriseValue.text = presenter.getSunriseTime(weather)
        sunsetPointValue.text = presenter.getSunsetTime(weather)
        pressureValue.text = String(weather.main.pressure) + " hPa"
        visibilityValue.text = String(weather.visibility) + " meters"
    }
    
    func updateNetworkStatus(_ message: String) {

    }
    
    func presentViewController(_ controller: UIViewController) {
        self.present(controller, animated: true)
    }
    
}
