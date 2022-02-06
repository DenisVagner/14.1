//
//  CitiesInFavorite+CoreDataClass.swift
//  
//
//  Created by Денис Вагнер on 04.02.2022.
//
//

import Foundation
import CoreData


public class CitiesInFavorite: NSManagedObject {
    convenience init() {
        
        // Создание нового объекта
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "CitiesInFavorite"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }

}
