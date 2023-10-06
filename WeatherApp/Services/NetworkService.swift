//
//  NetworkService.swift
//

import Foundation
import UIKit.UIImage

// MARK: Structs for comfortable use after receiving parsed data

struct ForecastData {
    var date: String
    var maxtemp: Double
    var mintemp: Double
    var avghumidity: Double
    var chanceRain: Double
    var iconString: String
    var iconText: String
    var icon: UIImage?
    
    init(weatherForecast: WeatherForecast.Forecastday?) {
        self.date = weatherForecast?.date ?? "None"
        self.maxtemp = weatherForecast?.day.maxtemp_c ?? -1
        self.mintemp = weatherForecast?.day.mintemp_c ?? -1
        self.avghumidity = weatherForecast?.day.avghumidity ?? -1
        self.chanceRain = weatherForecast?.day.daily_chance_of_rain ?? -1
        self.iconText = weatherForecast?.day.condition.text ?? "None"
        self.iconString = weatherForecast?.day.condition.icon ?? "None"
    }
}

struct CurrentWeatherData {
    var name: String
    var temp: Double
    var wind: Double
    var feelslike: Double
    var visibility: Double
    var cloud: Double
    var pressure: Double
    var icon: UIImage?
    var iconString: String
    init(currentWeather: CurrentWeather?) {
        self.name = currentWeather?.location.name! ?? "None"
        self.temp = currentWeather?.current.temp_c ?? -1
        self.wind = currentWeather?.current.wind_kph ?? -1
        self.feelslike = currentWeather?.current.feelslike_c ?? -1
        self.visibility = currentWeather?.current.vis_km ?? -1
        self.cloud = currentWeather?.current.cloud ?? -1
        self.pressure = currentWeather?.current.pressure_mb ?? -1
        self.iconString = currentWeather?.current.condition.icon ?? "None"
    }
}

final class NetworkService {
    var errorFlag = false
    var customError: CustomError? = nil
    var forecast: WeatherForecast?
    var currentWeather: CurrentWeather?
    var currentWeatherData: CurrentWeatherData?
    var forecastData: [ForecastData] = []
    let placeholderImage = Model.placeholderImage!
    
// MARK: Doing request(endpoints: /current.json, /forecast.json)
    
    func allRequests(cityName: String, completion: @escaping(CustomError?) -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        APIManager.shared.request(endpoint: URLExtension.currentWeatherEndpoint.rawValue + cityName, method: .GET) { [weak self] result in
            guard let self = self else { return}
            ParseService.shared.parseResponse(res: result, myData: &self.currentWeather, decodeStruct: CurrentWeather.self, errorFlag: &self.errorFlag, customError: &customError)
            currentWeatherData = CurrentWeatherData(currentWeather: self.currentWeather)
            !errorFlag ? downloadCurrentImage { dispatchGroup.leave() } : dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global()) {
            if !self.errorFlag {
                dispatchGroup.enter()
                APIManager.shared.request(endpoint: URLExtension.forecastEndpoint.rawValue + cityName + URLExtension.days.rawValue, method: .GET) {[weak self] result in
                    guard let self = self else { return }
                    ParseService.shared.parseResponse(res: result, myData: &self.forecast, decodeStruct: WeatherForecast.self, errorFlag: &self.errorFlag, customError: &customError)
                    for i in self.forecast!.forecast.forecastday {
                        forecastData.append(ForecastData(weatherForecast: i))
                    }
                    
                    downloadForecastImages {
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(self.customError)
            }
        }
    }
}

// MARK: Request for downloading images

extension NetworkService {
    func downloadCurrentImage(completion: @escaping () -> Void) {
        APIManager.shared.requstImage(url: URL(string: "https:" +  currentWeatherData!.iconString)!) {[weak self] result in
            switch result {
            case .success(let data):
                self?.currentWeatherData?.icon = UIImage(data: data)!
            case .failure(_):
                self?.currentWeatherData?.icon = self!.placeholderImage
            }
            completion()
        }
    }
    
    func downloadForecastImages(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        for (i, value) in forecastData.enumerated() {
            let imageURLString = value.iconString
            let imageURL = URL(string: "https:" + imageURLString)!
            dispatchGroup.enter()
            APIManager.shared.requstImage(url: imageURL) {[weak self] result in
                switch result {
                case .success(let data):
                    self?.forecastData[i].icon = (UIImage(data: data)!)
                case .failure(_):
                    self?.forecastData[i].icon = self!.placeholderImage
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .global()) {
            self.saveToCoreData()
            completion()
        }
    }
    
// MARK: Saving process
    
    func saveToCoreData() {
        let storageService = StorageService()
        if storageService.isEmpty() {
            storageService.saveToCoreData(currentWeather: currentWeatherData!, weatherForecast: forecastData)
        } else {
            storageService.updateCoreData(currentWeather: currentWeatherData!, weatherForecast: forecastData)
        }
    }
}
