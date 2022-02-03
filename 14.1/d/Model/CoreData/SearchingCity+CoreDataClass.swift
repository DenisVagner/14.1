//
//  SearchingCity+CoreDataClass.swift
//  14.1
//
//  Created by Денис Вагнер on 02.02.2022.
//
//

import Foundation
import CoreData


public class SearchingCity: NSManagedObject {
    convenience init() {
        
        // Создание нового объекта
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "SearchingCity"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }
}
