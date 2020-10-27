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
        let task = Task(context: context)
        task.name = name
        task.value = Int16(value) ?? 0
        task.repeatFrequency = Int16(repeatFrequency.rawValue)
        task.ddl = hasDdl ? ddl : nil
        task.desc = desc
        task.done = done
        task.starred = starred
        return task
    }
}
