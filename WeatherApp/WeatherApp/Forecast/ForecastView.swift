//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import UIKit

protocol ForecastViewer: AnyObject {
    func updateViewWithForecast(_ forecast: Forecast)
    func updateViewWithError(_ message: String)
    func presentViewController(_ viewController: UIViewController)
    func updateCurrentLocation(_ location: CurrentLocation)
}

final class ForecastView: UIViewController {
    
    lazy var safeArea: UILayoutGuide = view.safeAreaLayoutGuide
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .white
        tableView.register(ForecastCell.self, forCellReuseIdentifier: "ForecastCell")
        tableView.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)
        tableView.sectionHeaderTopPadding = 1
        tableView.separatorColor = UIColor(red: 70 / 255, green: 71 / 255, blue: 72 / 255, alpha: 1.0)
        tableView.allowsSelection = false
        return tableView
    }()
    
    lazy var networkStateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [networkStateLabel, retryButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var networkStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading data ..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var retryButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.tintColor = .white
        button.setTitle("Retry", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    var presenter: ForecastPresenter!
    var array: [[CurrentWeather]] = []
    var currentLocation: CurrentLocation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        setupConstraints()
    }
    
    @objc func refreshData() {
        presenter.refreshData()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(networkStateStackView)
    }
    
    private func setupUI() {
        retryButton.isHidden = true
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
            networkStateStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            networkStateStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            networkStateStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
        ])
    }

}

extension ForecastView: ForecastViewer {
    func updateCurrentLocation(_ location: CurrentLocation) {
        currentLocation = location
    }
    
    func updateViewWithForecast(_ forecast: Forecast) {
        self.array = presenter.getArrayOfCurrentWeathers()
        tableView.delegate = self
        tableView.dataSource = self
        networkStateStackView.isHidden = true
        tableView.reloadData()
        tableView.isHidden = false
        retryButton.isHidden = true
    }
    
    func updateViewWithError(_ message: String) {
        tableView.isHidden = true
        networkStateStackView.isHidden = false
        retryButton.isHidden = false
        networkStateLabel.text = message
    }
    
    func presentViewController(_ viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
}

extension ForecastView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
                returnedView.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)

                let label = UILabel(frame: CGRect(x: 20, y: 10, width: 300, height: 18))

                label.text = presenter.getTitleForSection(section: section)
                label.textColor = .white
                returnedView.addSubview(label)

                return returnedView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] (_, _, _) in
            let weather = self!.array[indexPath.section][indexPath.row]
            self!.presenter.shareForecast(weather)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [shareAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastCell
        let weather = array[indexPath.section][indexPath.row]
        cell.setupCell(currentWeather: weather)
        return cell
    }
    
}

extension ForecastView: UITableViewDelegate {
    
}
