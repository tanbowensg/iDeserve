//
//  genMockTasks.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/17.
//

import Foundation
import SwiftUI
import CoreData

func genMockTasks (_ context: NSManagedObjectContext) -> [Task] {
    let normalTask = Task.init(context: context)
    normalTask.id = UUID()
    normalTask.name = "读完《财务成本管理》"
    normalTask.difficulty = Int16(Difficulty.hard.rawValue)
    normalTask.timeCost = Int16(10)

    let repeatTask = Task.init(context: context)
    repeatTask.id = UUID()
    repeatTask.name = "完成今天的锻炼任务"
    normalTask.difficulty = Int16(Difficulty.easy.rawValue)
    normalTask.timeCost = Int16(1)
    repeatTask.repeatFrequency = 1

    let ddlTask = Task.init(context: context)
    ddlTask.id = UUID()
    ddlTask.name = "提交app审核材料"
    normalTask.difficulty = Int16(Difficulty.easy.rawValue)
    normalTask.timeCost = Int16(2)
    ddlTask.ddl = Date()

    let doneTask = Task.init(context: context)
    doneTask.id = UUID()
    doneTask.name = "剪辑九寨沟旅游的vlog"
    normalTask.difficulty = Int16(Difficulty.medium.rawValue)
    normalTask.timeCost = Int16(4)
    doneTask.done = true

    return [normalTask, repeatTask, ddlTask, doneTask]
}
