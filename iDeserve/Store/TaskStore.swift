//
//  TaskStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/9.
//

import Foundation
import SwiftUI
import CoreData

final class TaskStore: ObservableObject {
    var moc = CoreDataContainer.shared.context
    static var shared = TaskStore()
    private var recordStore = RecordStore.shared
    private var pointsStore = PointsStore.shared
    
//    用于替代原来的 TaskState.toModel
    func updateOrCreate (taskState: TaskState, goal: Goal) -> Task {
//        首先根据uuid从coredata中看看有没有这个任务
        let taskRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        taskRequest.predicate = NSPredicate(format: "%K == %@", "id", taskState.id as CVarArg)

        do {
            let fetchedTasks = try moc.fetch(taskRequest) as! [Task]
            if fetchedTasks.count == 0 {
    //            若不存在这个任务，就创建它
                return self.createTask(taskState: taskState)
            } else {
    //            若存在任务就直接修改已存在任务
                return self.updateTask(targetTask: fetchedTasks[0], taskState: taskState)
            }
        } catch {
            print("updateOrCreate任务时出现错误")
            return Task(context: self.moc)
        }
    }

    func updateTask (
        targetTask: Task,
        taskState: TaskState
    ) -> Task {
        targetTask.name = taskState.name
        targetTask.repeatFrequency = Int16(taskState.repeatFrequency.rawValue)
        targetTask.repeatTimes = Int16(taskState.repeatTimes)
        targetTask.ddl = taskState.hasDdl ? Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: taskState.ddl) : nil
        targetTask.desc = taskState.desc
        targetTask.done = taskState.done
        targetTask.starred = taskState.starred
        targetTask.difficulty = Int16(taskState.difficulty.rawValue)
        targetTask.timeCost = Int16(taskState.timeCost)
        
        if targetTask.parent?.id != taskState.goalId && taskState.goalId != nil {
            updateTaskGoal(task: targetTask, goalId: taskState.goalId!)
        }
    
        do {
            try self.moc.save()
        } catch let error  {
            print(error)
            fatalError("更新任务到 coredata中失败")
        }
        return targetTask
    }

    func createTask (taskState: TaskState) -> Task {
        let newTask = Task(context: self.moc)
        newTask.id = UUID()
        newTask.createdTime = Date()
        
        if let goalId = taskState.goalId {
            updateTaskGoal(task: newTask, goalId: goalId)
        }
        return self.updateTask(targetTask: newTask, taskState: taskState)
    }
    
    func completeTask (_ task: Task) {
        task.done = true
        task.lastCompleteTime = Date()
        task.completeTimes = task.completeTimes + 1
        task.nextRefreshTime = getNextRefreshTime(task)

//        如果是无间隔重复任务，就把状态变回未完成
        if (task.completeTimes < task.repeatTimes
            && task.repeatFrequency == RepeatFrequency.unlimited.rawValue
        ) {
            task.done = false
            task.nextRefreshTime = nil
        }

        let taskValue = task.timeCost * task.difficulty
//      加分
        self.pointsStore.add(Int(taskValue))
//      插入完成记录
        self.recordStore.createRecord(name: task.name!, kind: .task, value: Int(taskValue))

        do {
            try self.moc.save()
        } catch {
            print("完成任务失败")
        }
        
    }
    
    func removeTask(_ task: Task) {
        self.moc.delete(task)
    }
    
    func updateTaskGoal(task: Task, goalId: UUID) -> Void {
        let goalRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Goal")
        goalRequest.predicate = NSPredicate(format: "%K == %@", "id", goalId as CVarArg)

        do {
            let fetchedGoals = try moc.fetch(goalRequest) as! [Goal]
            if fetchedGoals.count > 0 {
                task.parent = fetchedGoals[0]
            }
        } catch {
            print("保存任务的时候没有从coredata中找到对应的目标")
        }
    }
}
