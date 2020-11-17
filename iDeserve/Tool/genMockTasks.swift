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
    normalTask.value = 50

    let repeatTask = Task.init(context: context)
    repeatTask.id = UUID()
    repeatTask.name = "完成今天的锻炼任务"
    repeatTask.value = 8
    repeatTask.repeatFrequency = 1

    let ddlTask = Task.init(context: context)
    ddlTask.id = UUID()
    ddlTask.name = "提交app审核材料"
    ddlTask.value = 2
    ddlTask.ddl = Date()

    let doneTask = Task.init(context: context)
    doneTask.id = UUID()
    doneTask.name = "剪辑九寨沟旅游的vlog"
    doneTask.value = 100
    doneTask.done = true

    return [normalTask, repeatTask, ddlTask, doneTask]
}
