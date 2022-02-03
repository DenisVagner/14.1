//
//  AppDelegate.swift
//  14.1
//
//  Created by Денис Вагнер on 28.12.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let managedObject = SearchingCity()
        
        // Установка значения атрибута
        managedObject.name = "111"
        
        // Извлечение значения атрибута
        // let name = managedObject.entity.name
        // print("name = \(name ?? "")")
        
        // Запись объекта
        CoreDataManager.instance.saveContext()
        
        // Извлечение записей
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchingCity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) //(fetchRequest) //self.managedObjectContext.execute(fetchRequest)
            for result in results as! [NSManagedObject] {
                print("name = \(result.value(forKey: "name") ?? "")")
            }
        } catch {
            print(error)
        }
        
        // let context = getContext()
        //        let fetchRequest: NSFetchRequest<SearchingCity> = Task.fetchRequest()
        //        if let objects = try? context.fetch(fetchRequest) {
        //            context.delete(objects[indexPath.row])
        //        }
        //        do {
        //            try context.save()
        //        } catch let error as NSError {
        //            print(error.localizedDescription)
        //        }
        
        
        
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "14.1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
}

