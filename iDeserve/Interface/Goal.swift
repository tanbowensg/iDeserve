//
//  Goal.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/20.
//

import Foundation
import SwiftUI

enum GoalType: String, CaseIterable {
    case study = "study"
    case exam = "exam"
    case exercise = "exercise"
    case job = "job"
    case money = "money"
    case hobby = "hobby"
    case social = "social"
    case habit = "habit"
    case writing = "writing"
}

struct GoalReward {
    var name: String
    var importance: Importance
    var basicRewardBase: Int
    var allRpeatRewardBase: Int
    var beforeDdlRewardBase: Int
    
    let RewardRatioMap: [Importance: Float] = [
        Importance.normal: 0.1,
        Importance.important: 0.2,
        Importance.epic: 0.4
    ]
    
    var fixedReward: Int {
        getImportanceValue(importance)
    }

    var basicReward: Int {
        Int(ceil(Float(basicRewardBase) * RewardRatioMap[importance]!))
    }
    var allRpeatReward: Int {
        Int(ceil(Double(allRpeatRewardBase) * AllRpeatRewardRatio))
    }
    var beforeDdlReward: Int {
        Int(ceil(Double(beforeDdlRewardBase) * BeforeDdlRewardRatio))
    }
    var totalReward: Int {
        fixedReward + basicReward + allRpeatReward + beforeDdlReward
    }
}

extension Goal {
    var color: Color {
        ImportanceColor[Importance(rawValue: Int(self.importance))!]!
    }
    
    var _tasks: Set<Task> {
        tasks as! Set<Task>
    }

    var goalReward: GoalReward {
        let allRpeatRewardBase = _tasks.reduce(0, { (sum: Int, task: Task)  in
            if task.repeatFrequency != RepeatFrequency.never.rawValue && task.repeatTimes == task.completeTimes {
                return sum + task.ts.totalValue
            }
            return sum
        })

        let beforeDdlRewardBase = _tasks.reduce(0, { (sum: Int, task: Task)  in
            if task.ddl != nil && task.lastCompleteTime != nil && task.lastCompleteTime! < task.ddl! {
                return sum + task.ts.totalValue
            }
            return sum
        })
        
        return GoalReward(
            name: self.name!,
            importance: Importance(rawValue: Int(self.importance)) ?? Importance.normal,
            basicRewardBase: self.gotValue,
            allRpeatRewardBase: allRpeatRewardBase,
            beforeDdlRewardBase: beforeDdlRewardBase
        )
    }
    
    var value: Int {
        return self.tasks!.reduce(0, { (result, task) -> Int in
            let _task = task as! Task
            let taskValue = Int(_task.timeCost) * Int(_task.difficulty)
            let totalValue = taskValue * Int(_task.repeatTimes)
            return result + totalValue
        })
    }
    
    var totalValue: Int {
        _tasks.reduce(0, {(sum, task: Task) in
            return sum + task.ts.totalValue
        })
    }
    
    var gotValue: Int {
        _tasks.reduce(0, {(sum, task: Task) in
            return sum + task.ts.gotValue
        })
    }
}
