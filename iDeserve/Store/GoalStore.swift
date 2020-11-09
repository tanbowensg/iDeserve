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

//    @Published var goals: [Goal] = []

//    init () {
//        do {
//            let goalRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Goal")
//            goalRequest.sortDescriptors = []
//            let fetchedGoals = try moc.fetch(goalRequest) as! [Goal]
//            self.goals = fetchedGoals
//        } catch {
//            fatalError("读取coredata的目标数据失败: \(error)")
//        }
//    }

    func updateGoal (
        targetGoal: Goal,
        name: String,
        difficulty: Difficulty,
        desc: String,
        tasks: [TaskState]
    ) {
        targetGoal.name = name
        targetGoal.difficulty = Int16(difficulty.rawValue)
        targetGoal.desc = desc
        let goalTasks = tasks.map { taskState in
            return taskState.toModel(context: self.moc)
        }
        targetGoal.tasks = NSSet(array: goalTasks)

        do {
            try self.moc.save()
        } catch {
            fatalError("更新目标到 coredata中失败")
        }
    }

    func createGoal (
        name: String,
        difficulty: Difficulty,
        desc: String,
        tasks: [TaskState]
    ) {
        let newGoal = Goal(context: self.moc)
        newGoal.id = UUID()

        self.updateGoal(
            targetGoal: newGoal,
            name: name,
            difficulty: difficulty,
            desc: desc,
            tasks: tasks
        )
    }
}
