//
//  TaskState.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import Foundation

extension Task {
    var value: Int16 {
        return self.timeCost * self.difficulty
    }
}

struct TaskState: Hashable, Identifiable {
    var originTask: Task?
    var id = UUID()
    var name: String = ""
    var repeatFrequency: RepeatFrequency = .never
    var repeatTimes: String = ""
    var hasDdl: Bool = false
    var ddl: Date = Date()
    var desc: String = ""
    var done: Bool = false
    var starred: Bool = false
    var goalName: String = ""
    var goalId: UUID?
    var timeCost: String = ""
    var difficulty: Difficulty = .easy
    var completeTimes: Int = 0
    
    var value: Int {
        let time = Int(timeCost) ?? 1
        return time * difficulty.rawValue
    }

    init (_ originTask: Task?) {
        if let existTask = originTask {
            self.originTask = existTask

            id = existTask.id!
            name = existTask.name ?? ""
            repeatFrequency = RepeatFrequency(rawValue: Int(existTask.repeatFrequency)) ?? .never
            repeatTimes = String(existTask.repeatTimes)
            hasDdl = existTask.ddl != nil
            desc = existTask.desc ?? ""
            done = existTask.done
            starred = existTask.starred
            goalName = existTask.parent?.name ?? ""
            goalId = existTask.parent?.id
            timeCost = String(existTask.timeCost)
            difficulty = Difficulty(rawValue: Int(existTask.difficulty)) ?? .easy
            goalName = existTask.parent?.name ?? ""
            goalId = existTask.parent?.id
            completeTimes = Int(existTask.completeTimes)
            
            if let existDdl = existTask.ddl {
                ddl = existDdl
            }
        }
    }

    init (name: String) {
        self.name = name
    }
}
