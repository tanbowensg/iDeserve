//
//  TaskState.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import Foundation

struct TaskState: Hashable, Identifiable {
    var originTask: Task?
    var id = UUID()
    var name: String = ""
    var value: String = "0"
    var repeatFrequency: RepeatFrequency = .never
    var repeatTimes: String = "0"
    var hasDdl: Bool = false
    var ddl: Date = Date()
    var desc: String = ""
    var done: Bool = false
    var starred: Bool = false
    var goalName: String = ""

    init (_ originTask: Task?) {
        if let existTask = originTask {
            self.originTask = existTask

            id = existTask.id!
            name = existTask.name ?? ""
            value = String(existTask.value)
            repeatFrequency = RepeatFrequency(rawValue: Int(existTask.repeatFrequency)) ?? .never
            repeatTimes = String(existTask.repeatTimes)
            hasDdl = existTask.ddl != nil
            desc = existTask.desc ?? ""
            done = existTask.done
            starred = existTask.starred
            goalName = existTask.parent?.name ?? ""
            
            if let existDdl = existTask.ddl {
                ddl = existDdl
            }
        }
    }
}
