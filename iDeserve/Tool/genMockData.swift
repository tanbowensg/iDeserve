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
    repeatTask.repeatTimes = 20

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

func genMockRewards (_ context: NSManagedObjectContext) -> [Reward] {
    let normalReward = Reward.init(context: context)
    normalReward.id = UUID()
    normalReward.name = "一款桌游"
    normalReward.value = 30
    normalReward.repeatFrequency = Int16(RepeatFrequency.never.rawValue)
    normalReward.desc = "一款300元以内的桌游"
    normalReward.isSoldout = false
    
    let longReward = Reward.init(context: context)
    longReward.id = UUID()
    longReward.name = "去九寨沟或者张家界旅游"
    longReward.value = 200
    longReward.repeatFrequency = Int16(RepeatFrequency.never.rawValue)
    longReward.desc = "七日游"
    longReward.isSoldout = false

    let littleReward = Reward.init(context: context)
    littleReward.id = UUID()
    littleReward.name = "一杯喜茶"
    littleReward.value = 3
    littleReward.repeatFrequency = Int16(RepeatFrequency.never.rawValue)
    littleReward.desc = "好喝的喜茶"
    littleReward.isSoldout = false

    let bigReward = Reward.init(context: context)
    normalReward.id = UUID()
    normalReward.name = "顶配 Mackbook pro"
    normalReward.value = 1000
    normalReward.repeatFrequency = Int16(RepeatFrequency.never.rawValue)
    normalReward.desc = "七日游"
    normalReward.isSoldout = false

    return [normalReward, longReward, littleReward, bigReward]
}
