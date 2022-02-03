//
//  LocalNames+CoreDataProperties.swift
//  14.1
//
//  Created by Денис Вагнер on 02.02.2022.
//
//

import Foundation
import CoreData


extension LocalNames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalNames> {
        return NSFetchRequest<LocalNames>(entityName: "LocalNames")
    }

    @NSManaged public var en: String?
    @NSManaged public var ru: String?
    @NSManaged public var searchingCity: SearchingCity?

}

extension LocalNames : Identifiable {

}
