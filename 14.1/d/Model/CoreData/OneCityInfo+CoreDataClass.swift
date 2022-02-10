//
//  OneCityInfo+CoreDataClass.swift
//  
//
//  Created by Денис Вагнер on 10.02.2022.
//
//

import Foundation
import CoreData


public class OneCityInfo: NSManagedObject {
    convenience init() {
        
        // Создание нового объекта
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "OneCityInfo"), insertInto: CoreDataManager.instance.managedObjectContext)
        
    }

}
