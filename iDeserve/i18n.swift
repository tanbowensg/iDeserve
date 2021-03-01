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
