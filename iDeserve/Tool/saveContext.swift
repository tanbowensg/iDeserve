//
//  saveContext.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/19.
//

import CoreData
import Foundation

func saveContext(context: NSManagedObjectContext) {
  if context.hasChanges {
    do {
      try context.save()
    } catch {
      // The context couldn't be saved.
      // You should add your own error handling here.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
