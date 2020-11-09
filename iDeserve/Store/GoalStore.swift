//
//  GoalStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/9.
//

import Foundation
import SwiftUI
import CoreData

final class GoalStore: ObservableObject {
    var moc = CoreDataContainer.shared.context
    static var shared = GoalStore()

    @Published var goals: [Goal] = []

    init () {
        do {
            let goalRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Goal")
            goalRequest.sortDescriptors = []
            let fetchedGoals = try moc.fetch(goalRequest) as! [Goal]
            self.goals = fetchedGoals
        } catch {
            fatalError("读取coredata的目标数据失败: \(error)")
        }
    }
}
