//
//  SearchingCity+CoreDataProperties.swift
//  
//
//  Created by Денис Вагнер on 03.02.2022.
//
//

import Foundation
import CoreData


extension SearchingCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchingCity> {
        return NSFetchRequest<SearchingCity>(entityName: "SearchingCity")
    }

    @NSManaged public var country: String?
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    

}
