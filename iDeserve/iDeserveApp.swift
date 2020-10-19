//
//  iDeserveApp.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/9/30.
//

import SwiftUI
import CoreData

@main
struct iDeserveApp: App {
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iDeserve")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var body: some Scene {
        let context = persistentContainer.viewContext
        WindowGroup {
            Tab()
                .environment(\.managedObjectContext, context)
        }
    }
}
