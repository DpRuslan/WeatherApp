//
//  StorageService.swift
//

import Foundation
import CoreData

final class StorageService {
    let managedContext = AppDelegate.coreDataStack.managedContext
    
// MARK: Check if CoreData is empty(first launch)
    func isEmpty() -> Bool {
        do {
            if try managedContext.count(for: NSFetchRequest<CurrentWeatherCoreData>(entityName: "CurrentWeatherCoreData")) == 0 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("Error -\(error.localizedDescription)")
        }
        
        return false
    }
    
// MARK: Save to CoreData(first launch)
    func saveToCoreData(currentWeather: CurrentWeatherData, weatherForecast: [ForecastData]) {
        let newCurrentWeather = CurrentWeatherCoreData(context: managedContext)
        newCurrentWeather.name = currentWeather.name
        newCurrentWeather.temp = currentWeather.temp
        newCurrentWeather.feelslike = currentWeather.feelslike
        newCurrentWeather.visibility = currentWeather.visibility
        newCurrentWeather.cloud = currentWeather.cloud
        newCurrentWeather.pressure = currentWeather.pressure
        newCurrentWeather.wind = currentWeather.wind
        newCurrentWeather.icon = currentWeather.icon?.pngData()
        
        for i in weatherForecast {
            let newWeatherForecast = WeatherForecastCoreData(context: managedContext)
            newWeatherForecast.date = i.date
            newWeatherForecast.maxtemp = i.maxtemp
            newWeatherForecast.mintemp = i.mintemp
            newWeatherForecast.avghumidity = i.avghumidity
            newWeatherForecast.chanceRain = i.chanceRain
            newWeatherForecast.iconText = i.iconText.localized()
            newWeatherForecast.icon = i.icon?.pngData()
        }
        
        AppDelegate.coreDataStack.saveContext()
    }
    
// MARK: Update objects values in CoreData(not first request)
    
    func updateCoreData(currentWeather: CurrentWeatherData, weatherForecast: [ForecastData]) {
        var existingWeather: CurrentWeatherCoreData!
        var existingForecast: [WeatherForecastCoreData] = []
        do {
            let fetchWeatherRequest = CurrentWeatherCoreData.fetchRequest()
            existingWeather = try managedContext.fetch(fetchWeatherRequest).first
    
            let fetchForecastRequest = WeatherForecastCoreData.fetchRequest()
            existingForecast = try managedContext.fetch(fetchForecastRequest)
        } catch {
            print("Error fetching: \(error)")
        }
        
        existingWeather.name = currentWeather.name
        existingWeather.temp = currentWeather.temp
        existingWeather.feelslike = currentWeather.feelslike
        existingWeather.visibility = currentWeather.visibility
        existingWeather.cloud = currentWeather.cloud
        existingWeather.pressure = currentWeather.pressure
        existingWeather.wind = currentWeather.wind
        existingWeather.icon = currentWeather.icon?.pngData()
        
        for (i, value) in existingForecast.enumerated() {
            value.date = weatherForecast[i].date
            value.maxtemp = weatherForecast[i].maxtemp
            value.mintemp = weatherForecast[i].mintemp
            value.avghumidity = weatherForecast[i].avghumidity
            value.chanceRain = weatherForecast[i].chanceRain
            value.iconText = weatherForecast[i].iconText.localized()
            value.icon = weatherForecast[i].icon?.pngData()
        }
        
        AppDelegate.coreDataStack.saveContext()
    }
}
