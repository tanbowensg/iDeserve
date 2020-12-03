//
//  Moc.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/19.
//

import SwiftUI
import Foundation
import CoreData

final class CoreDataContainer {
    static let shared = CoreDataContainer()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iDeserve")
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.iDeserve")!
        let storeURL = containerURL.appendingPathComponent("iDeserve.sqlite")

        let description = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { description, error in
            if let error = error {
                print("coreData加载失败")
            }
        }
        return container
    }()

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show the error here
            }
        }
    }
}
