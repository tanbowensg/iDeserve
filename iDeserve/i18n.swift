//
//  i18n.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/28.
//

import Foundation

let MYDAY_TEXT = NSLocalizedString("今日任务", comment: "")
let REWARD_STORE_TEXT = NSLocalizedString("奖励商店", comment: "")
let GOAL_LIST_TEXT = NSLocalizedString("目标列表", comment: "")
let RECORD_LIST_TEXT = NSLocalizedString("历史记录", comment: "")

let TODAY_TASK_TEXT = NSLocalizedString("今天的任务", comment: "")
let COMPLETED_TASK_TEXT = NSLocalizedString("完成的任务", comment: "")

let FREQUENCY_NEVER_TEXT = NSLocalizedString("从不", comment: "")
let FREQUENCY_DAILY_TEXT = NSLocalizedString("每天", comment: "")
let FREQUENCY_WEEKLY_TEXT = NSLocalizedString("每周", comment: "")
let FREQUENCY_MONTHLY_TEXT = NSLocalizedString("每月", comment: "")
let FREQUENCY_UNLIMITED_TEXT = NSLocalizedString("无间隔重复", comment: "")
let FREQUENCY_TWODAYS_TEXT = NSLocalizedString("每隔一天", comment: "")

let RewardFilterText: [RewardFilterType: String] = [
    .createDesc: NSLocalizedString("创建时间从旧到新", comment: ""),
    .createAsc: NSLocalizedString("创建时间从新到旧", comment: ""),
    .valueAsc: NSLocalizedString("价格从低到高", comment: ""),
    .valueDesc: NSLocalizedString("价格从高到低", comment: "")
]

let RepeatFrequencyText: [RepeatFrequency: String] = [
    .never: NSLocalizedString("从不", comment: ""),
    .daily: NSLocalizedString("每天", comment: ""),
    .weekly: NSLocalizedString("每周", comment: ""),
    .monthly: NSLocalizedString("每月", comment: ""),
    .unlimited: NSLocalizedString("无间隔重复", comment: ""),
    .twoDays: NSLocalizedString("每隔一天", comment: ""),
]

let GoalTypeText: [GoalType: String] = [
    .exercise: NSLocalizedString("锻炼", comment: ""),
    .exam: NSLocalizedString("考试", comment: ""),
    .money: NSLocalizedString("理财", comment: ""),
    .habit: NSLocalizedString("习惯", comment: ""),
    .writing: NSLocalizedString("创作", comment: ""),
    .hobby: NSLocalizedString("兴趣", comment: ""),
    .job: NSLocalizedString("工作", comment: ""),
    .study: NSLocalizedString("学习", comment: ""),
    .social: NSLocalizedString("社交", comment: ""),
]

let RewardTypeText: [RewardType: String] = [
    .entertainment: NSLocalizedString("娱乐", comment: ""),
    .game: NSLocalizedString("游戏", comment: ""),
    .drink: NSLocalizedString("饮料", comment: ""),
    .digital: NSLocalizedString("数码", comment: ""),
    .movie: NSLocalizedString("电影", comment: ""),
    .food: NSLocalizedString("美食", comment: ""),
    .travel: NSLocalizedString("旅游", comment: ""),
    .rest: NSLocalizedString("休息", comment: ""),
    .shopping: NSLocalizedString("购物", comment: ""),
    .system: NSLocalizedString("系统", comment: ""),
]

let DifficultyText: [Difficulty: String] = [
    .easy: NSLocalizedString("轻松", comment: ""),
    .medium: NSLocalizedString("普通", comment: ""),
    .hard: NSLocalizedString("挑战", comment: "")
]

let DifficultyDescText: [Difficulty: String] = [
    .easy: NSLocalizedString("不费吹灰之力就能完成。", comment: ""),
    .medium: NSLocalizedString("跟平时学习工作差不多。", comment: ""),
    .hard: NSLocalizedString("必须聚精会神、全力以赴。", comment: "")
]

let ImportanceText: [Importance: String] = [
    .normal: NSLocalizedString("一般", comment: ""),
    .important: NSLocalizedString("重要", comment: ""),
    .epic: NSLocalizedString("史诗", comment: "")
]

let ImportanceDescText: [Importance: String] = [
    .normal: NSLocalizedString("普通的目标，不完成也没关系。", comment: ""),
    .important: NSLocalizedString("要尽力去完成。", comment: ""),
    .epic: NSLocalizedString("非完成不可，影响重大。", comment: "")
]

let GOAL_RESULT_DESC_TITLE = NSLocalizedString("目标结算说明", comment: "目标结算说明弹窗的标题")
let GOAL_RESULT_DESC = NSLocalizedString("目标结算奖励由一下几个部分构成：\n目标完成奖励：根据目标重要性，额外获得部分奖励\n完成了全部的重复次数：额外获得1.1倍奖励\n在截止日期前完成目标：额外获得1.1倍奖励", comment: "目标结算说明弹窗的内容")

let REWARD_VALUE_DESC_TITLE = NSLocalizedString("奖励价值参考", comment: "奖励价值参考弹窗的标题")
let REWARD_VALUE_DESC = NSLocalizedString("不同奖励的价值因人而异。下面是一些奖励和任务之间换算的示例，供你参考。", comment: "奖励价值说明弹窗的内容")
let IMPORTANCE_HELP_DESC = NSLocalizedString("你可以给目标设定重要性。目标的重要性越高，那么你在完成这个目标时，得到的额外奖励也越多。\n普通：100 + 1.1x\n重要：200 + 1.2x\n史诗：400 + 1.4x\nx为已经完成的目标的任务的坚果总和", comment: "重要性说明的内容")

// 初始化数据里的文案J
let INIT_GOAL_TITLE = NSLocalizedString("期末考班级第一名（示例）", comment: "")
let INIT_TASK_0_TITLE = NSLocalizedString("背100个单词（示例）", comment: "")
let INIT_TASK_1_TITLE = NSLocalizedString("做一套数学卷子（示例）", comment: "")
let INIT_TASK_2_TITLE = NSLocalizedString("做一套英语卷子（示例）", comment: "")
let INIT_TASK_3_TITLE = NSLocalizedString("写一篇作文（示例）", comment: "")
let INIT_TASK_4_TITLE = NSLocalizedString("整理错题（示例）", comment: "")

let INIT_REWARD_2_TITLE = NSLocalizedString("一杯奶茶（示例）", comment: "")
let INIT_REWARD_3_TITLE = NSLocalizedString("一台 Kindle（示例）", comment: "")
let INIT_REWARD_4_TITLE = NSLocalizedString("打一个小时游戏（示例）", comment: "")
let INIT_REWARD_5_TITLE = NSLocalizedString("新疆八日游（示例）", comment: "")

let GOAL_LIMIT_ALERT = NSLocalizedString("你的目标数量已达到上限 3 个。你可以删除不需要的目标，或者购买 Pro 版解除限制。", comment: "")
let REWARD_LIMIT_ALERT = NSLocalizedString("你的目标数量已达到上限 5 个。你可以删除不需要的奖励，或者购买 Pro 版解除限制。", comment: "")
let DELETE_RECORD_ALERT = NSLocalizedString("撤销记录是购买 Pro 版的功能。\n购买 Pro 版即可解锁撤销记录功能。", comment: "")
let NO_ENOUGH_NUTS_ALERT = NSLocalizedString("你的坚果不够了，再攒一攒吧。或者你可以购买 Pro 版，允许透支坚果", comment: "")
let BACKUP_DATA_PAY_ALERT = NSLocalizedString("iCloud 数据备份是 Pro 版的功能。购买 Pro 版后就能确保坚果安全，万无一失。", comment: "")

let FIRST_MYDAY_TEXT = NSLocalizedString("欢迎！我们已经为你准备了一些示例任务，帮助你上手。\n\n这是“今日任务”界面，展现的是你今天要做的事情。右滑可以完成任务。\n\n更多用法可以在设置页面中查看“App上手指南”。", comment: "")
let FIRST_GOAL_LIST_TEXT = NSLocalizedString("“目标列表”页面展示了你所有的目标。我们已经为你创建了一些示例目标。\n\n目标里还可以创建任务。把目标拆分成一个个任务，可以更有效率地达成目标哦。\n\n完成任务或目标以后，就可以得到坚果奖励。", comment: "")
let FIRST_REWARD_STORE_TEXT = NSLocalizedString("“奖励商店”页面展示了你设置的所有奖励。\n\n在这里你可以花费坚果，兑换你设置的奖励。\n\n如果你不清楚对于奖励需要设置多少坚果，可以参考设置中的“App上手指南”。", comment: "")
let FIRST_RECORDS_TEXT = NSLocalizedString("“历史记录”页面展示了你之前获取和花费坚果的记录。\n\n现在日历是一片空白，因为你还没有完成过任务。赶紧去完成任务吧！", comment: "")
