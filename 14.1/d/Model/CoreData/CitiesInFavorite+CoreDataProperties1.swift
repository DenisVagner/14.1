//
//  CitiesInFavorite+CoreDataProperties.swift
//  
//
//  Created by Денис Вагнер on 04.02.2022.
//
//

import Foundation
import CoreData


extension CitiesInFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CitiesInFavorite> {
        return NSFetchRequest<CitiesInFavorite>(entityName: "CitiesInFavorite")
    }

    @NSManaged public var name_en: String
    @NSManaged public var name_ru: String?
    @NSManaged public var cur_temp: String

}
