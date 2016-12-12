//
//  CoreDataStack.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import CoreData


class CoreDataStack {
    
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
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
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
}
