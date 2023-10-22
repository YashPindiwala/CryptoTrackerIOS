//
//  CoreDataStack.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-11.
//

import Foundation
import CoreData

class CoreDataStack{
    private var dataModelName: String
    init(dataModelName: String) {
        self.dataModelName = dataModelName
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.dataModelName)
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        return container
    }()
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    func saveContext(){
        guard managedContext.hasChanges else {return}
        do{
            try managedContext.save()
        }catch{
            let nsError = error as NSError
            fatalError("Saving error: \(nsError) - \(nsError.userInfo)")
        }
    }
}
