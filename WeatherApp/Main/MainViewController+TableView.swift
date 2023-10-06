//
//  MainViewController+TableView.swift
//

import UIKit

// MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == weatherTableView {
            return viewModel.weatherNumberOf()
        } else if tableView == forecastTableView {
            return viewModel.forecastNumberOf()
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == weatherTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.configure(
                titleText: viewModel.weatherAt(at: indexPath).cellTitle,
                valueText: viewModel.weatherAt(at: indexPath).cellValue
            )
            return cell
            
        } else if tableView == forecastTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.configure(
                day: viewModel.forecastAt(at: indexPath.row).date ?? "None",
                descrIcon: viewModel.forecastAt(at: indexPath.row).iconText ?? "None",
                iconImage: UIImage(data: viewModel.forecastAt(at: indexPath.row).icon!) ?? Model.placeholderImage!,
                maxTemp: "\(viewModel.forecastAt(at: indexPath.row).maxtemp)",
                minTemp: "\(viewModel.forecastAt(at: indexPath.row).mintemp)",
                humidity: "\(viewModel.forecastAt(at: indexPath.row).avghumidity)",
                rain: "\(viewModel.forecastAt(at: indexPath.row).chanceRain)"
            )
            return cell
        }
        return UITableViewCell()
    }
}
