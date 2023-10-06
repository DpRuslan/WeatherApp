//
//  MainViewModel+Enum.swift
//  

import Foundation

// MARK: enum for comfortable populating cell in WeatherCell class

extension MainViewModel {
    enum Weather {
        case windSpeed(value: String)
        case pressure(value: String)
        case visibility(value: String)
        case cloud(value: String)
        case feelslike(value: String)
        
        var cellTitle: String {
            switch self {
            case .windSpeed(_):
                return "Wind Speed: ".localized()
            case .pressure(_):
                return "Pressure: ".localized()
            case .visibility(_):
                return "Visibility: ".localized()
            case .cloud(_):
                return "Cloud: ".localized()
            case .feelslike(_):
                return "Feels like: ".localized()
            }
        }
        
        var cellValue: String {
            switch self {
            case .windSpeed(let value):
                return value
            case .pressure(let value):
                return value
            case .visibility(let value):
                return value
            case .cloud(let value):
                return value
            case .feelslike(let value):
                return value
            }
        }
    }
}
