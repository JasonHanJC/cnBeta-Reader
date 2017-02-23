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
    
    fileprivate lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = self.mainContext
        return managedObjectContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    fileprivate lazy var psc: NSPersistentStoreCoordinator = {
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
            
    func save() {
        
        if !mainContext.hasChanges && !privateContext.hasChanges {
            return
        }
        
        privateContext.perform({
            do {
                try self.privateContext.save()
                
                self.mainContext.performAndWait {
                    do {
                        try self.mainContext.save()
                        
                    } catch let error as NSError {
                        print("Error: \(error.localizedDescription)")
                        abort()
                    }
                }
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        })

        
    }
    
    fileprivate override init() {
        super.init()
    }
}

extension CoreDataStack {
    
    func createObjectForEntity(_ entityName: String, context: NSManagedObjectContext) -> NSManagedObject? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }
    
    func getObjectsForEntity(_ context: NSManagedObjectContext, entityName: String, sortByKey key: String? = nil, isAscending: Bool = false, withPredicate predicate: NSPredicate? = nil, limit: Int = 0) -> [Any]? {
        
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
        if let feeds = getObjectsForEntity(mainContext, entityName: "Feed", sortByKey: "publishedDate", isAscending: false, withPredicate: nil, limit: 1) {
            return feeds.first as! Feed?
        }
        return nil;
    }
    
    func deleteObject(_ object: NSManagedObject, context: NSManagedObjectContext) {
        context.delete(object)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
    }
    
    func deleteObjectsForEntity(_ context: NSManagedObjectContext, entityName : String, withPredicate predicate: NSPredicate? = nil) {
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
                let objects = try(mainContext.fetch(fetchRequest)) as? [NSManagedObject]
                
                for object in objects! {
                    mainContext.delete(object)
                }
            }
            
            try mainContext.save()
        } catch let err {
            print(err)
        }
    }
    
}
