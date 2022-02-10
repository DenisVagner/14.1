//
//  OneCityInfo+CoreDataProperties.swift
//  
//
//  Created by Денис Вагнер on 10.02.2022.
//
//

import Foundation
import CoreData


extension OneCityInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OneCityInfo> {
        return NSFetchRequest<OneCityInfo>(entityName: "OneCityInfo")
    }

    @NSManaged public var humidity: String?
    @NSManaged public var wind_speed: String?
    @NSManaged public var temp_max: String?
    @NSManaged public var temp_min: String?
    @NSManaged public var feels_like: String?
    @NSManaged public var temp: String?
    @NSManaged public var main_description: String?
    @NSManaged public var city_name: String?
}
