//
//  JSON.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/22.
//

import Foundation
import CoreData

struct TaskJson: Codable {
    var name: String = ""
    var repeatFrequency: Int16
    var repeatTimes: Int16
    var ddl: Date?
    var desc: String
    var done: Bool = false
    var starred: Bool = true
    var timeCost: Int16
    var difficulty: Int16
    var completeTimes: Int16
    var nextRefreshTime: Date?
    var createdTime: Date
    var lastCompleteTime: Date?
    
    init(t: Task) {
        name = t.name!
        repeatFrequency = t.repeatFrequency
        repeatTimes = t.repeatTimes
        ddl = t.ddl
        desc = t.desc ?? ""
        done = t.done
        starred = t.starred
        timeCost = t.timeCost
        difficulty = t.difficulty
        completeTimes = t.completeTimes
        nextRefreshTime = t.nextRefreshTime
        createdTime = t.createdTime!
        lastCompleteTime = t.lastCompleteTime
    }
}

func importTaskJson(taskJson: TaskJson, goal: Goal) -> Task{
    let t = Task(context: CoreDataContainer.shared.context)
    
    t.id = UUID()
    t.name = taskJson.name
    t.repeatFrequency = taskJson.repeatFrequency
    t.repeatTimes = taskJson.repeatTimes
    t.ddl = taskJson.ddl
    t.desc = taskJson.desc
    t.done = taskJson.done
    t.starred = taskJson.starred
    t.timeCost = taskJson.timeCost
    t.difficulty = taskJson.difficulty
    t.completeTimes = taskJson.completeTimes
    t.nextRefreshTime = taskJson.nextRefreshTime
    t.createdTime = taskJson.createdTime
    t.lastCompleteTime = taskJson.lastCompleteTime
    return t
}
