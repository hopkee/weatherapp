//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Valya on 9.06.22.
//

import UIKit

protocol ForecastViewer: AnyObject {
    func updateViewWithForecast(_ forecast: Forecast)
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
        return tableView
    }()
    
    var presenter: ForecastPresenter!
    var array: [[CurrentWeather]] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupUI() {
//        view.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

}

extension ForecastView: ForecastViewer {
    func updateViewWithForecast(_ forecast: Forecast) {
        self.array = presenter.getArrayOfCurrentWeathers()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

extension ForecastView: UITableViewDelegate {
    
}

extension ForecastView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40)) //set these values as necessary
                returnedView.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1.0)

                let label = UILabel(frame: CGRect(x: 20, y: 10, width: 300, height: 18))

                label.text = presenter.getTitleForSection(section: section)
                label.textColor = .white
                returnedView.addSubview(label)

                return returnedView
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
