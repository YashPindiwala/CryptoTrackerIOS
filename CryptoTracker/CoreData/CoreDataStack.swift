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
        let continer = NSPersistentContainer(name: self.dataModelName)
        continer.loadPersistentStores(){
            storeDescription,error in
            if let error = error as NSError?{
                fatalError("Unresolved error occured: \(error) - \(error.userInfo)")
            }
        }
        return continer
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
