//
//  TaskState.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import Foundation
import CoreData

struct TaskState: Hashable, Identifiable {
    var originTask: Task?
    var id = UUID()
    var name: String = ""
    var value: String = "0"
    var repeatFrequency: RepeatFrequency = .never
    var hasDdl: Bool = false
    var ddl: Date = Date()
    var desc: String = ""
    var done: Bool = false
    var starred: Bool = false

    init (_ originTask: Task?) {
        if let existTask = originTask {
            self.originTask = existTask

            id = existTask.id!
            name = existTask.name ?? ""
            value = String(existTask.value)
            repeatFrequency = RepeatFrequency(rawValue: Int(existTask.repeatFrequency)) ?? .never
            hasDdl = existTask.ddl != nil
            desc = existTask.desc ?? ""
            done = existTask.done
            starred = existTask.starred
            
            if let existDdl = existTask.ddl {
                ddl = existDdl
            }
        }
    }
    
    func toModel(context: NSManagedObjectContext) -> Task {
        var targetTask: Task
//        首先根据uuid从coredata中看看有没有这个任务
        let taskRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        taskRequest.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)

        do {
            let fetchedTasks = try context.fetch(taskRequest) as! [Task]
            if fetchedTasks.count == 0 {
    //            若不存在这个任务，就创建它
                targetTask = Task(context: context)
                print("创建了新的任务")
            } else {
    //            若存在任务就直接修改已存在任务
                targetTask = fetchedTasks[0]
                print("修改已有任务")
            }
        } catch {
            targetTask = Task(context: context)
            print("持久化存储任务时出现错误")
        }

        targetTask.id = id
        targetTask.name = name
        targetTask.value = Int16(value) ?? 0
        targetTask.repeatFrequency = Int16(repeatFrequency.rawValue)
        targetTask.ddl = hasDdl ? ddl : nil
        targetTask.desc = desc
        targetTask.done = done
        targetTask.starred = starred
        return targetTask
    }
}
