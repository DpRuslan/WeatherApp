//
//  MainViewModel.swift
//

import Foundation
import UIKit.UIImage
import Combine
import CoreData
import CoreLocation

final class MainViewModel {
    enum Event {
        case update
        case error(errorDescr: String)
        case loading
        case endLoading
    }
    
    let storageService = StorageService()
    let networkService = NetworkService()
    
    let topLabelText = Model.topLabelText.localized()
    let searchPlaceholder = Model.searchPlaceholder.localized()
    let tableViewHeaderText = Model.tableViewHeaderText.localized()
    
    var weatherDataSource: [Weather]?
    var forecastDataSource: [WeatherForecastCoreData] = []
    
    var cityName: String?
    var weatherTemp: String?
    var weatherImage: UIImage?
    
    var loadingFlag = false
    var customError: CustomError? = nil
    
// MARK: NSFetchedResultsControllers
    
    lazy var weatherResultController =  makeFetchedResultsController(
        for: CurrentWeatherCoreData.self,
        sortKey: nil
    )
    
    lazy var forecastResultController = makeFetchedResultsController(
        for: WeatherForecastCoreData.self,
        sortKey: "date"
    )
    
// MARK: Combine(for notifying controller)
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var eventPubisher: AnyPublisher<Event, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    func eventOccured(event: Event) {
        eventSubject.send(event)
    }
    
// MARK: Making request after pressing search in searchBar and notifying controller about result
    
    func request(cityName: String) {
        if loadingFlag || checkEmptyCoreData() {
            eventOccured(event: .loading)
            loadingFlag = true
        } else {
            loadingFlag = true
        }
        
        networkService.allRequests(cityName: cityName) {[weak self] error in
            if self!.networkService.errorFlag {
                self?.eventOccured(event: .error(errorDescr: error!.localizedDescription))
            } else {
                do {
                    try self?.weatherResultController.performFetch()
                    try self?.forecastResultController.performFetch()
                    self?.populateDataSources()
                } catch {
                    print("Fetch error: \(error)")
                }
                
                self?.eventOccured(event: .update)
            }
            
            self?.eventOccured(event: .endLoading)
        }
    }
    
    func weatherNumberOf() -> Int {
        weatherDataSource?.count ?? 0
    }
    
    func forecastNumberOf() -> Int {
        forecastDataSource.count
    }
    
    func weatherAt(at indexPath: IndexPath) -> Weather {
        return weatherDataSource![indexPath.row]
    }
    
    func forecastAt(at index: Int) -> WeatherForecastCoreData {
        return forecastDataSource[index]
    }
}

// MARK: Logic for understanding if it is firstLaunch or not

extension MainViewModel {
    func checkCoreData() {
        if !checkEmptyCoreData() {
            do {
                try self.weatherResultController.performFetch()
                try self.forecastResultController.performFetch()
                self.populateDataSources()
                eventOccured(event: .update)
                request(cityName: cityName!)
            } catch {
                print("Fetch error: \(error)")
            }
        }
    }
    
    func checkEmptyCoreData() -> Bool {
        storageService.isEmpty()
    }
}

// MARK: Make generic func to receive NSFetchedResultsControllers for different CoreData Entities

extension MainViewModel {
    func makeFetchedResultsController<T: NSManagedObject>(for entityType: T.Type, sortKey: String?) -> NSFetchedResultsController<T> {
        let request = T.fetchRequest() as! NSFetchRequest<T>
        
        if let sortKey = sortKey {
            request.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: true)]
        } else {
            request.sortDescriptors = []
        }
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: AppDelegate.coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return controller
    }
}

// MARK: Populating dataSources for use in tableViews

extension MainViewModel {
    func populateDataSources() {
        weatherDataSource = []
        let weather = weatherResultController.fetchedObjects!.first!
        weatherDataSource = [
            .windSpeed(value: "\(Int(weather.wind))" + " km/h".localized()),
            .pressure(value: "\(Int(weather.pressure))" + " kPa".localized()),
            .visibility(value: "\(Int(weather.visibility))" + " km".localized()),
            .cloud(value: "\(Int(weather.cloud))%"),
            .feelslike(value: "\(Int(weather.feelslike))°")
        ]
        
        cityName = weather.name
        weatherTemp = "\(weather.temp)" + "°"
        weatherImage = UIImage(data: weather.icon!)
        
        let forecast = forecastResultController.fetchedObjects
        forecastDataSource = []
        for i in forecast! {
            forecastDataSource.append(i)
        }
    }
}
