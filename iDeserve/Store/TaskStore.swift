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
    
//    用于替代原来的 TaskState.toModel
    func updateOrCreate (taskState: TaskState, goal: Goal) -> Task {
//        首先根据uuid从coredata中看看有没有这个任务
        let taskRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        taskRequest.predicate = NSPredicate(format: "%K == %@", "id", taskState.id as CVarArg)

        do {
            let fetchedTasks = try moc.fetch(taskRequest) as! [Task]
            if fetchedTasks.count == 0 {
    //            若不存在这个任务，就创建它
                return self.createTask(taskState: taskState, goal: goal)
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
        targetTask.value = Int16(taskState.value) ?? 0
        targetTask.repeatFrequency = Int16(taskState.repeatFrequency.rawValue)
        targetTask.ddl = taskState.hasDdl ? taskState.ddl : nil
        targetTask.desc = taskState.desc
        targetTask.done = taskState.done
        targetTask.starred = taskState.starred
    
        do {
            try self.moc.save()
        } catch let error  {
            print(error)
            fatalError("更新任务到 coredata中失败")
        }
        return targetTask
    }

    func createTask (
        taskState: TaskState,
        goal: Goal?
    ) -> Task {
        let newTask = Task(context: self.moc)
        newTask.id = UUID()
        newTask.parent = goal

        return self.updateTask(targetTask: newTask, taskState: taskState)
    }
    
    func completeTask (_ task: Task) {
        task.done = true
//      插入完成记录
        self.recordStore.createRecord(name: task.name!, kind: .task, value: Int(task.value))

        do {
            try self.moc.save()
        } catch {
            print("完成任务失败")
        }
        
    }
    
    func removeTask(_ task: Task) {
        self.moc.delete(task)
    }
}
