//
//  WeatherForecastCoreData+CoreDataProperties.swift
//  

import Foundation
import CoreData


extension WeatherForecastCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherForecastCoreData> {
        return NSFetchRequest<WeatherForecastCoreData>(entityName: "WeatherForecastCoreData")
    }

    @NSManaged public var date: String?
    @NSManaged public var icon: Data?
    @NSManaged public var maxtemp: Double
    @NSManaged public var avghumidity: Double
    @NSManaged public var mintemp: Double
    @NSManaged public var chanceRain: Double
    @NSManaged public var iconText: String?

}

extension WeatherForecastCoreData : Identifiable {

}
