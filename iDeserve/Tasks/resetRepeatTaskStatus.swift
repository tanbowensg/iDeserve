//
//  resetRepeatTaskStatus.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/18.
//

import Foundation
import CoreData

let frequencyDayMap: [RepeatFrequency: Int] = [
    .daily: 1,
    .monthly: 30,
    .weekly: 7,
    .never: 99999999,
    .twoDays: 2,
    .unlimited: 0,
]

//重置重复任务的完成状态
func resetRepeatTaskStatus () {
    let moc = GlobalStore.shared.moc
    let taskRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")

    do {
        let fetchedTasks = try moc.fetch(taskRequest) as! [Task]
        fetchedTasks.forEach {task in
            if checkTaskStatusShouldReset(task) {
                task.done = false
            }
        }
        try moc.save()
    } catch {
        print("执行任务状态重置时出错")
    }
}

//检查该任务的完成状态是否需要重置
func checkTaskStatusShouldReset(_ task: Task) -> Bool {
    if (task.done
        && task.repeatFrequency != RepeatFrequency.never.rawValue
        && task.completeTimes < task.repeatTimes
    ) {
        let dateDiff = Calendar.current.dateComponents([.day], from: task.lastCompleteTime!, to: Date())
        print(dateDiff)
        let frequency = RepeatFrequency(rawValue: Int(task.repeatFrequency))!
        return dateDiff.day! >= frequencyDayMap[frequency]!
    }
    return false
}
