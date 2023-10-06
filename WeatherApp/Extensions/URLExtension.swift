//
//  URLExtension.swift
//

import Foundation

enum URLExtension: String {
    case baseURL = "https://api.weatherapi.com/v1"
    case currentWeatherEndpoint = "/current.json?key=f777e9c2914243aa9fe150700230210&q="
    case forecastEndpoint = "/forecast.json?key=f777e9c2914243aa9fe150700230210&q="
    case days = "&days=10"
}
