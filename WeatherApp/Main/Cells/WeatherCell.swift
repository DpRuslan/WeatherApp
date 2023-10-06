//
//  WeatherCell.swift
//

import UIKit

class WeatherCell: UITableViewCell {
    private var titleLabel = UILabel(frame: .zero)
    private var valueLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension WeatherCell {
    private func setupUI() {
        titleLabel.setStyle(textColor: .black, font: UIFont.boldSystemFont(ofSize: 20), isHidden: false)
        valueLabel.setStyle(textColor: .black, font: UIFont.systemFont(ofSize: 20), isHidden: false)
    }
}

extension WeatherCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

// MARK: Populating Forecast cell

extension WeatherCell {
    func configure(titleText: String, valueText: String) {
        titleLabel.text = titleText
        valueLabel.text = valueText
    }
}
