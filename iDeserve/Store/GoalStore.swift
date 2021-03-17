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
    private var taskStore = TaskStore.shared
    private var pointsStore = PointsStore.shared

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
        type: GoalType,
        importance: Importance,
        desc: String,
        tasks: [TaskState]
    ) {
        targetGoal.name = name
        targetGoal.type = type.rawValue
        targetGoal.importance = Int16(importance.rawValue)
        targetGoal.desc = desc
        let goalTasks = tasks.map { taskState in
            return self.taskStore.updateOrCreate(taskState: taskState, goal: targetGoal)
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
        type: GoalType,
        importance: Importance,
        desc: String,
        tasks: [TaskState]
    ) {
        let newGoal = Goal(context: self.moc)
        newGoal.id = UUID()

        self.updateGoal(
            targetGoal: newGoal,
            name: name,
            type: type,
            importance: importance,
            desc: desc,
            tasks: tasks
        )
    }
    
    func completeGoal (_ goal: Goal) {
//        TODO: 暂时还没加目标的固定奖励
//        let value = getImportanceValue(Importance(rawValue: Int(goal.importance)) ?? Importance.normal)
        pointsStore.add(goal.goalReward.totalReward)
        goal.done = true
        
        do {
            try self.moc.save()
        } catch {
            fatalError("完成目标失败")
        }
    }
    
    func removeGoal (_ goal: Goal) {
        moc.delete(goal)

        do {
            try self.moc.save()
        } catch {
            fatalError("删除目标失败")
        }
    }
}
