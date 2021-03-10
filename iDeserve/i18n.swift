//
//  i18n.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/28.
//

import Foundation

let MYDAY_TEXT = NSLocalizedString("我的一天", comment: "")
let REWARD_STORE_TEXT = NSLocalizedString("奖励商店", comment: "")
let GOAL_LIST_TEXT = NSLocalizedString("目标任务", comment: "")
let RECORD_LIST_TEXT = NSLocalizedString("历史记录", comment: "")

let TODAY_TASK_TEXT = NSLocalizedString("今天的任务", comment: "")
let COMPLETED_TASK_TEXT = NSLocalizedString("完成的任务", comment: "")

let GoalTypeText: [GoalType: String] = [
    .exercise: NSLocalizedString("锻炼", comment: ""),
    .health: NSLocalizedString("健康", comment: ""),
    .hobby: NSLocalizedString("兴趣", comment: ""),
    .job: NSLocalizedString("工作", comment: ""),
    .study: NSLocalizedString("学习", comment: ""),
]

let RewardTypeText: [RewardType: String] = [
    .entertainment: NSLocalizedString("娱乐", comment: ""),
    .food: NSLocalizedString("吃喝", comment: ""),
    .travel: NSLocalizedString("旅游", comment: ""),
    .rest: NSLocalizedString("休息", comment: ""),
    .shopping: NSLocalizedString("购物", comment: ""),
]

let GOAL_RESULT_DESC_TITLE = NSLocalizedString("目标结算说明", comment: "目标结算说明弹窗的标题")
let GOAL_RESULT_DESC = NSLocalizedString("目标结算奖励由一下几个部分构成：\n目标完成奖励：根据目标重要性，额外获得部分奖励\n完成了全部的重复次数：额外获得1.1倍奖励\n在截止日期前完成目标：额外获得1.1倍奖励", comment: "目标结算说明弹窗的内容")

let REWARD_VALUE_DESC_TITLE = NSLocalizedString("奖励价值参考", comment: "奖励价值参考弹窗的标题")
let REWARD_VALUE_DESC = NSLocalizedString("不同奖励的价值因人而异，取决于你愿意付出多少努力来换取它。下面是一些参考。\n10 = 帮妈妈洗一次碗\n20 = 做一个小时作业\n40 = 高强度健身一小时\n40 = 在 12 点前睡觉\n160 = 工作或学习八小时\n800 = 上一个星期班\n1920 = 996一星期", comment: "奖励价值说明弹窗的内容")
