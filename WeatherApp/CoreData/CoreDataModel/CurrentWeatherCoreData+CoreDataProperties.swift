//
//  CurrentWeatherCoreData+CoreDataProperties.swift
//  

import Foundation
import CoreData


extension CurrentWeatherCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherCoreData> {
        return NSFetchRequest<CurrentWeatherCoreData>(entityName: "CurrentWeatherCoreData")
    }

    @NSManaged public var cloud: Double
    @NSManaged public var feelslike: Double
    @NSManaged public var icon: Data?
    @NSManaged public var name: String?
    @NSManaged public var pressure: Double
    @NSManaged public var temp: Double
    @NSManaged public var visibility: Double
    @NSManaged public var wind: Double

}

extension CurrentWeatherCoreData : Identifiable {

}
