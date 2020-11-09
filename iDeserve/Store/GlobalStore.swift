//
//  GlobalStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/9.
//

import Foundation
import SwiftUI
import CoreData

final class GlobalStore: ObservableObject {
    var moc = CoreDataContainer.shared.context
    static var shared = GlobalStore()

    var pointsStore = PointsStore.shared
    
//    @FetchRequest(fetchRequest: taskRequest) var tasks: FetchedResults<Task>
    @Published var goals: [Goal] = []

//    static var goalRequest: NSFetchRequest<Goal> {
//        let request: NSFetchRequest<Goal> = NSFetchRequest(entityName: "Goal")
//        request.sortDescriptors = []
//        return request
//   }
//
    init () {
        do {
            let goalRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Goal")
            goalRequest.sortDescriptors = []
            let fetchedGoals = try moc.fetch(goalRequest) as! [Goal]
            self.goals = fetchedGoals
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }

//    static var goalRequest: NSFetchRequest<Goal> {
//        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
//        request.sortDescriptors = []
//        return request
//   }
}
