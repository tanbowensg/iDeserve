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
            if task.nextRefreshTime != nil && task.nextRefreshTime! < Date() {
                task.nextRefreshTime = nil
                task.done = false
            }
        }
        try moc.save()
    } catch {
        print("执行任务状态重置时出错")
    }
}
//获取重复任务下次的刷新时间
func getNextRefreshTime(_ task: Task) -> Date? {
    let defaults = UserDefaults.standard
    let startOfDay = defaults.integer(forKey: START_TIME_OF_DAY)

    if (task.done
        && task.repeatFrequency != RepeatFrequency.never.rawValue
        && task.completeTimes < task.repeatTimes
    ) {
        let frequency = RepeatFrequency(rawValue: Int(task.repeatFrequency))!
        let lastCompleteHour = Calendar.current.component(.hour, from: task.lastCompleteTime!)
        var intervalDays = frequencyDayMap[frequency]!
        if lastCompleteHour < startOfDay {
            intervalDays -= 1
        }
        var due = Calendar.current.date(byAdding: .day, value: intervalDays, to:  task.lastCompleteTime!)!
        due = Calendar.current.date(bySettingHour: startOfDay, minute: 0, second: 0, of: due)!
        return due
    }
    return nil
}
