//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Valya on 15.06.22.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherImage, centerStackView, tempLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var centerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [drawSpacer(), timeLabel, weatherConditionLabel, drawSpacer()])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var weatherImage: UIImageView = {
        let image = UIImage(named: "wi-na")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 40.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weatherConditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupViews()
        setContraints()
    }
    
    func setupCell(currentWeather: CurrentWeather) {
        weatherImage.image = UIImage(named: currentWeather.weather[0].icon)!.withTintColor(.white)
        weatherConditionLabel.text = currentWeather.weather[0].description
        tempLabel.text = currentWeather.main.temp.rounded().removeZero + "°C"
        let date = Date(timeIntervalSince1970: Double(currentWeather.dt))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            dateFormatter.timeZone = .current
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let formatedTime = dateFormatter.string(from: date)
        timeLabel.text = formatedTime
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)
    }
    
    private func drawSpacer() -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spacer.heightAnchor.constraint(equalToConstant: 5)])
        return spacer
    }
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImage.heightAnchor.constraint(equalToConstant: 50),
            weatherImage.widthAnchor.constraint(equalToConstant: 50),
            centerStackView.widthAnchor.constraint(equalToConstant: 130),
        ])
    }
    
    private func setupViews() {
        addSubview(contentStackView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
