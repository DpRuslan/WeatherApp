//
//  APIModel.swift
// 

import Foundation

//MARK: Parsing Weather 

struct CurrentWeather: Decodable {
    var location: Location
    
    struct Location: Decodable {
        var name: String?
        var region: String?
        var country: String?
    }
    
    var current: Current
    
    struct Current: Decodable {
        var condition: Condition
        var temp_c: Double?
        var wind_kph: Double?
        var feelslike_c: Double?
        var vis_km: Double?
        var cloud: Double?
        var pressure_mb: Double?
        
        struct Condition: Decodable {
            var icon: String?
            var text: String
        }
    }
}

// MARK: Parsing Forecast

struct WeatherForecast: Decodable {
    var forecast: Forecast
    
    struct Forecast: Decodable {
        var forecastday: [Forecastday]
    }

    struct Forecastday: Decodable {
        var date: String?
        var day: Day
    }

    struct Day: Decodable {
        var condition: Condition
        var maxtemp_c: Double?
        var mintemp_c: Double?
        var avgtemp_c: Double?
        var daily_chance_of_rain: Double?
        var avghumidity: Double?
        
        struct Condition: Decodable {
            var icon: String?
            var text: String
        }
    }
}
