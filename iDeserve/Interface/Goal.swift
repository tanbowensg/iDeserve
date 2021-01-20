//
//  Goal.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/20.
//

import Foundation

extension Goal {
    var value: Int {
        return self.tasks!.reduce(0, { (result, task) -> Int in
            let _task = task as! Task
            let taskValue = Int(_task.timeCost) * Int(_task.difficulty)
            let totalValue = taskValue * Int(_task.repeatTimes)
            return result + totalValue
        })
    }
}
