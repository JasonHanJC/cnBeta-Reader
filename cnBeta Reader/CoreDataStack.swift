//
//  CoreDataStack.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import CoreData


class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    
    let modelName = "cnBeta-Reader"
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(self.modelName).sqlite")
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            print("Error adding persistent store.")
        }
        return coordinator
    }()
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
            
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
    
    private override init() {
        super.init()
    }
}

extension CoreDataStack {
    
    func createObjectForEntity(_ entityName: String) -> NSManagedObject? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }
    
    func test(first: Int = 100, second: Int) -> Int {
        return first + second
    }
    
    func getObjectsForEntity(_ entityName: String, sortByKey key: String? = nil, isAscending: Bool = false, withPredicate predicate: NSPredicate? = nil, limit: Int = 0) -> [Any]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if key != nil {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: key, ascending: isAscending)]
        }
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        if limit >= 0 {
            fetchRequest.fetchLimit = limit
        }
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
            return nil
        }
    }
    
    func getLatestFeed() -> Feed? {
        if let feeds = getObjectsForEntity("Feed", sortByKey: "publishedDate", isAscending: false, withPredicate: nil, limit: 1) {
            return feeds.first as! Feed?
        }
        return nil;
    }
    
    func deleteObject(object: NSManagedObject) {
        context.delete(object)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
    }
    
    func deleteObjectsForEntity(entityName : String, withPredicate predicate: NSPredicate? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        do {
            let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
            
            for object in objects! {
                context.delete(object)
            }
            
            try context.save()
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
    }
    
    
    func clearData() {
        do {
            let entities = managedObjectModel.entities
            
            for entity in entities {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                
                for object in objects! {
                    context.delete(object)
                }
            }
            
            try context.save()
        } catch let err {
            print(err)
        }
    }
    
}
