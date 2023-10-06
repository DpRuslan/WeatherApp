//
//  ForecastCell.swift
//

import UIKit

class ForecastCell: UITableViewCell {
    private var dayOfTheWeekLabel = UILabel(frame: .zero)
    private var descrIconLabel = UILabel(frame: .zero)
    private var iconImageView = UIImageView(frame: .zero)
    private var minTempLabel = UILabel(frame: .zero)
    private var maxTempLabel = UILabel(frame: .zero)
    private var humidityLabel = UILabel(frame: .zero)
    private var chanceRainLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        addSubview(dayOfTheWeekLabel)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        addSubview(humidityLabel)
        addSubview(chanceRainLabel)
        addSubview(descrIconLabel)
        addSubview(iconImageView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ForecastCell {
    private func setupUI() {
        dayOfTheWeekLabel.setStyle(textColor: .black, font: UIFont.boldSystemFont(ofSize: 23), isHidden: false)
        descrIconLabel.setStyle(textColor: .black, font: UIFont.boldSystemFont(ofSize: 20), isHidden: false)
        minTempLabel.setStyle(textColor: .black, font: UIFont.systemFont(ofSize: 18), isHidden: false)
        maxTempLabel.setStyle(textColor: .black, font: UIFont.systemFont(ofSize: 18), isHidden: false)
        humidityLabel.setStyle(textColor: .black, font: UIFont.systemFont(ofSize: 18), isHidden: false)
        chanceRainLabel.setStyle(textColor: .black, font: UIFont.systemFont(ofSize: 18), isHidden: false)

        iconImageView.contentMode = .scaleToFill
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension ForecastCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayOfTheWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayOfTheWeekLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            descrIconLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            descrIconLabel.topAnchor.constraint(equalTo: dayOfTheWeekLabel.bottomAnchor, constant: 8),

            maxTempLabel.leadingAnchor.constraint(equalTo: descrIconLabel.leadingAnchor),
            maxTempLabel.topAnchor.constraint(equalTo: descrIconLabel.bottomAnchor, constant: 4),

            minTempLabel.leadingAnchor.constraint(equalTo: maxTempLabel.trailingAnchor, constant: 8),
            minTempLabel.centerYAnchor.constraint(equalTo: maxTempLabel.centerYAnchor),

            humidityLabel.leadingAnchor.constraint(equalTo: descrIconLabel.leadingAnchor),
            humidityLabel.topAnchor.constraint(equalTo: maxTempLabel.bottomAnchor, constant: 4),

            chanceRainLabel.leadingAnchor.constraint(equalTo: descrIconLabel.leadingAnchor),
            chanceRainLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 4),
            chanceRainLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

// MARK: Populating Weather cell

extension ForecastCell {
    func configure(day: String, descrIcon: String, iconImage: UIImage, maxTemp: String, minTemp: String, humidity: String, rain: String) {
        dayOfTheWeekLabel.text = covertDateToDay(text: day)
        descrIconLabel.text = descrIcon
        iconImageView.image = iconImage
        maxTempLabel.text = "H: ".localized() + maxTemp + "°"
        minTempLabel.text = "L: ".localized() + minTemp + "°"
        humidityLabel.text = "Humidity: ".localized() + humidity + "%"
        chanceRainLabel.text = "Rain: ".localized() + rain + "%"
    }
}

// MARK: Converting received date in weekday

extension ForecastCell {
    func covertDateToDay(text: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let date = dateFormatter.date(from: text) {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            if calendar.isDate(date, inSameDayAs: today) {
                return "Today".localized()
            } else {
                dateFormatter.dateFormat = "EEEE"
                let dayOfWeek = dateFormatter.string(from: date)
                return (dayOfWeek.prefix(1).capitalized + dayOfWeek.dropFirst()).localized()
            }
        } else {
            return "Invalid Date"
        }
    }
}
