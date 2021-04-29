//
//  i18n.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/28.
//

import Foundation

let MYDAY_TEXT = NSLocalizedString("今日任务", comment: "")
let REWARD_STORE_TEXT = NSLocalizedString("奖励商店", comment: "")
let GOAL_LIST_TEXT = NSLocalizedString("目标任务", comment: "")
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
    .easy: NSLocalizedString("不费吹灰之力就能完成。不过，奖励也低。", comment: ""),
    .medium: NSLocalizedString("跟平时学习工作差不多的难度，还能接受。", comment: ""),
    .hard: NSLocalizedString("必须全力以赴才能完成。但奖励也很丰厚。", comment: "")
]

let ImportanceText: [Importance: String] = [
    .normal: NSLocalizedString("一般", comment: ""),
    .important: NSLocalizedString("重要", comment: ""),
    .epic: NSLocalizedString("史诗", comment: "")
]

let ImportanceDescText: [Importance: String] = [
    .normal: NSLocalizedString("普通的目标。", comment: ""),
    .important: NSLocalizedString("必须要完成。有额外奖励。", comment: ""),
    .epic: NSLocalizedString("非完成不可，影响重大。有大量额外奖励。", comment: "")
]

let GOAL_RESULT_DESC_TITLE = NSLocalizedString("目标结算说明", comment: "目标结算说明弹窗的标题")
let GOAL_RESULT_DESC = NSLocalizedString("目标结算奖励由一下几个部分构成：\n目标完成奖励：根据目标重要性，额外获得部分奖励\n完成了全部的重复次数：额外获得1.1倍奖励\n在截止日期前完成目标：额外获得1.1倍奖励", comment: "目标结算说明弹窗的内容")

let REWARD_VALUE_DESC_TITLE = NSLocalizedString("奖励价值参考", comment: "奖励价值参考弹窗的标题")
let REWARD_VALUE_DESC = NSLocalizedString("不同奖励的价值因人而异，取决于你愿意付出多少努力来换取它。下面是一些参考。\n10 = 帮妈妈洗一次碗\n20 = 做一个小时作业\n40 = 高强度健身一小时\n40 = 在 12 点前睡觉\n160 = 工作或学习八小时\n800 = 上一个星期班\n1920 = 996一星期", comment: "奖励价值说明弹窗的内容")

// 初始化数据里的文案J
let INIT_GOAL_TITLE = NSLocalizedString("上手坚果计划", comment: "")
let INIT_TASK_1_TITLE = NSLocalizedString("创建一个目标", comment: "")
let INIT_TASK_1_DESC = NSLocalizedString("点击目标列表页面右下角的“+”按钮，就可以创建目标了！\n目标是坚果计划的核心。", comment: "")
let INIT_TASK_2_TITLE = NSLocalizedString("了解任务", comment: "")
let INIT_TASK_2_DESC = NSLocalizedString("目标下可以创建任务。通过合理拆分任务，你可以更高效地达成目标。\n完成任务后可以获得坚果。每个任务的坚果数量是由任务的难度和估时决定的。你只需要设置难度和估时，我们就会自动算出这个任务的坚果数量。", comment: "")
let INIT_TASK_3_TITLE = NSLocalizedString("了解截止日期", comment: "")
let INIT_TASK_3_DESC = NSLocalizedString("这是一个有截止日期的任务。\n如果在截止日期前完成任务，那么在达成目标时，可以获得额外的坚果奖励。\n如果超过了截止日期，仍然可以完成任务，但是就没有额外奖励了。\n现在完成这个任务试试看吧。", comment: "")
let INIT_TASK_4_TITLE = NSLocalizedString("了解重复任务", comment: "")
let INIT_TASK_4_DESC = NSLocalizedString("这个任务是一个重复任务。完成重复任务之后，间隔一段时间后，可以再次完成，直到达到重复次数上限。\n 完成全部重复任务后，在达成目标时，可以获得额外的奖励。\n现在尝试一下完成这个任务吧。", comment: "")
let INIT_TASK_5_TITLE = NSLocalizedString("了解今日任务", comment: "")
let INIT_TASK_5_DESC = NSLocalizedString("“今日任务”是坚果计划的主页面，其中罗列了今天所有可以完成的任务。\n\n有两种类型的任务会自动显示在“今日任务”中：\n1. 轮到今天完成的重复任务。\n2. 最近一周将会截止的任务。\n\n另外，只要开启任务“在‘今日任务’中显示”选项，别的任务也显示在“今日任务”里。", comment: "")
let INIT_TASK_6_TITLE = NSLocalizedString("添加一个奖励", comment: "")
let INIT_TASK_6_DESC = NSLocalizedString("奖励机制是坚果计划的特色。通过完成任务和目标，你可以获得坚果。通过消耗坚果，你可以兑换你设置的奖励。\n\n现在就去创建一个奖励吧。", comment: "")
let INIT_TASK_7_TITLE = NSLocalizedString("完成一个目标", comment: "")
let INIT_TASK_7_DESC = NSLocalizedString("任何时候你都可以完成目标，即使目标下的任务没有全部完成。\n\n目标的奖励和任务的奖励时分开计算的。完成目标时会根据你在这个目标的任务中已经获得坚果数量，计算出完成目标的奖励。\n\n现在就完成这个目标试试看吧！", comment: "")

let INIT_REWARD_1_TITLE = NSLocalizedString("解锁松鼠日历", comment: "初始奖项：解锁松鼠日历")

