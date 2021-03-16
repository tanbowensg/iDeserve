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
    let defaults = UserDefaults.standard
    let startOfDay = defaults.integer(forKey: START_TIME_OF_DAY)
    print("一天开始的时间：\(startOfDay)")

    if (task.done
        && task.repeatFrequency != RepeatFrequency.never.rawValue
        && task.completeTimes < task.repeatTimes
    ) {
        print("上次完成时间\(task.lastCompleteTime!)")
        print("当前时间\(Date())")
        let frequency = RepeatFrequency(rawValue: Int(task.repeatFrequency))!
        let lastCompleteHour = Calendar.current.component(.hour, from: task.lastCompleteTime!)
        var intervalDays = frequencyDayMap[frequency]!
        if lastCompleteHour < startOfDay {
            intervalDays -= 1
        }
        print("应该间隔日:\(intervalDays)")
//        let dayDiff = Calendar.current.dateComponents([.day], from: task.lastCompleteTime!, to: Date())
//        print("实际间隔日:\(dayDiff.day)")
//        if dayDiff.day! > intervalDays {
//            return true
//        } else if dayDiff.day == intervalDays {
//            let currentHour = Calendar.current.component(.hour, from: Date())
//            print("当前几点:\(currentHour)")
//            return currentHour >= startOfDay
//        }
        var due = Calendar.current.date(byAdding: .day, value: intervalDays, to:  task.lastCompleteTime!)!
        due = Calendar.current.date(bySettingHour: startOfDay, minute: 0, second: 0, of: due)!
//        let modifiedDate = Calendar.current.date(byAdding: .hour, value: -startOfDay, to: task.lastCompleteTime!)!
//        let dateDiff = Calendar.current.dateComponents([.day], from: modifiedDate, to: Date())
        print("当前时间\(Date())")
        print("该刷新的时间\(due)")
        return Date() >= due
    }
    return false
}
