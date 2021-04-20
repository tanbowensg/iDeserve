//
//  TaskState.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI
import Foundation

extension Task {
    var value: Int16 {
        return self.timeCost * self.difficulty
    }
    
    var ts: TaskState {
        TaskState(self)
    }
}

struct TaskState: Hashable, Identifiable {
    var originTask: Task?
    var id = UUID()
    var name: String = ""
    var repeatFrequency: RepeatFrequency = .never
    var repeatTimes: Int = 1
    var hasDdl: Bool = false
    var ddl: Date = Date()
    var desc: String = ""
    var done: Bool = false
    var starred: Bool = false
    var goalName: String = ""
    var goalColor: Color?
    var goalId: UUID?
    var timeCost: Int = 1
    var difficulty: Difficulty = .easy
    var completeTimes: Int = 0
    var nextRefreshTime: Date?
    
    var value: Int {
        return timeCost * difficulty.rawValue
    }

    var totalValue: Int {
        return value * repeatTimes
    }
    
    var gotValue: Int {
        return value * Int(completeTimes)
    }

    init (_ originTask: Task?) {
        if let existTask = originTask {
            self.originTask = existTask

            id = existTask.id!
            name = existTask.name ?? ""
            repeatFrequency = RepeatFrequency(rawValue: Int(existTask.repeatFrequency)) ?? .never
            repeatTimes = Int(existTask.repeatTimes)
            hasDdl = existTask.ddl != nil
            desc = existTask.desc ?? ""
            done = existTask.done
            starred = existTask.starred
            goalName = existTask.parent?.name ?? ""
            goalId = existTask.parent?.id
            timeCost = Int(existTask.timeCost)
            difficulty = Difficulty(rawValue: Int(existTask.difficulty)) ?? .easy
            goalName = existTask.parent?.name ?? ""
            goalId = existTask.parent?.id
            completeTimes = Int(existTask.completeTimes)
            nextRefreshTime = existTask.nextRefreshTime
            goalColor = existTask.parent?.color
            
            if let existDdl = existTask.ddl {
                ddl = existDdl
            }
        }
    }

    init (name: String) {
        self.name = name
    }
}
