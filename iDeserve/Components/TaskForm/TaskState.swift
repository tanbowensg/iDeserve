//
//  TaskState.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import Foundation

struct TaskState: Hashable, Identifiable {
    var id = UUID()
    var name: String = ""
    var value: String = "0"
    var repeatFrequency: RepeatFrequency = .never
    var hasDdl: Bool = false
    var ddl: Date = Date()
    var desc: String = ""

    init (originTask: Task?) {
        if let existTask = originTask {
            name = existTask.name ?? ""
            value = String(existTask.value)
            repeatFrequency = RepeatFrequency(rawValue: Int(existTask.repeatFrequency)) ?? .never
            hasDdl = existTask.ddl != nil
            desc = existTask.desc ?? ""
            
            if let existDdl = existTask.ddl {
                ddl = existDdl
            }
        }
    }
    
    func toModel() -> Task {
        let task = Task()
        task.name = name
        task.value = Int16(value) ?? 0
        task.repeatFrequency = Int16(repeatFrequency.rawValue)
        task.ddl = hasDdl ? ddl : nil
        task.desc = desc
        return task
    }
}
