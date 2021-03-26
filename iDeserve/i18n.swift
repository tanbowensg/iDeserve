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
    .person: NSLocalizedString("社交", comment: ""),
]

let RewardTypeText: [RewardType: String] = [
    .entertainment: NSLocalizedString("娱乐", comment: ""),
    .food: NSLocalizedString("吃喝", comment: ""),
    .travel: NSLocalizedString("旅游", comment: ""),
    .rest: NSLocalizedString("休息", comment: ""),
    .shopping: NSLocalizedString("购物", comment: ""),
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
    .normal: NSLocalizedString("轻松", comment: ""),
    .important: NSLocalizedString("普通", comment: ""),
    .epic: NSLocalizedString("挑战", comment: "")
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
let INIT_GOAL_TITLE = NSLocalizedString("上手松鼠计划", comment: "")
let INIT_TASK_1_TITLE = NSLocalizedString("创建目标", comment: "")
let INIT_TASK_1_DESC = NSLocalizedString("目标是松鼠计划的核心。目标下还有为了实现目标而要完成的任务。完成目标时，可以得到额外的坚果奖励！\n一个目标应该有一个明确的达成条件，以便于你判断目标是否达成了。\n点击目标列表页面右下角的“+”按钮，就可以创建目标了！", comment: "")
let INIT_TASK_2_TITLE = NSLocalizedString("了解任务", comment: "")
let INIT_TASK_2_DESC = NSLocalizedString("一个目标下会有若干个任务。通过合理拆分任务，你可以更高效地达成目标。\n完成任务后可以获得坚果。每个任务的坚果数量是由任务的难度和估时决定的。你只需要设置难度和估时，我们就会自动算出这个任务的坚果数量。", comment: "")
let INIT_TASK_3_TITLE = NSLocalizedString("了解截止日期", comment: "")
let INIT_TASK_3_DESC = NSLocalizedString("这是一个有截止日期的任务。如果在截止日期前完成任务，那么在达成目标时，可以获得额外的坚果奖励。如果超过了截止日期，仍然可以完成任务，但是就没有额外奖励了。\n现在完成这个任务试试看吧。", comment: "")
let INIT_TASK_4_TITLE = NSLocalizedString("了解重复任务", comment: "")
let INIT_TASK_4_DESC = NSLocalizedString("这个任务是一个重复任务。完成重复任务之后，间隔一段时间后，可以再次完成，直到达到重复次数上限。\n每次完成，都可以得到同样的奖励。完成全部重复任务后，在达成目标时，可以获得额外的奖励。\n现在尝试一下完成这个任务吧。", comment: "")
let INIT_TASK_5_TITLE = NSLocalizedString("了解我的一天", comment: "")
let INIT_TASK_5_DESC = NSLocalizedString("“我的一天”是坚果计划的主页面，其中罗列了今天所有可以完成的任务。这样以来，你只需要浏览一个列表，就可以了解今天所有可以完成的任务。\n\n有两种类型的任务会自动显示在“我的一天”中：\n1. 轮到今天完成的重复任务。\n2. 最近一周将会截止的任务。\n\n另外，只要开启“在‘我的一天’中显示”选项，你也可以把别的任务显示在“我的一天”里。", comment: "")
let INIT_TASK_6_TITLE = NSLocalizedString("添加一个奖励", comment: "")
let INIT_TASK_6_DESC = NSLocalizedString("奖励机制是坚果计划的特色。通过完成任务和目标，你可以获得坚果。通过消耗坚果，你可以兑换你设置的奖励。\n\n初次使用的你，可能不知道该为奖励设置多少价格。我们已经为你预设了一些常见的奖励作为参考。\n\n记住，奖励的价值完全因人而异。因为奖励的价格，体现的是每个人兑换这个奖励的心理负担大小，因此奖励是非常个性化的。\n\n现在就去创建一个奖励吧。", comment: "")
let INIT_TASK_7_TITLE = NSLocalizedString("达成目标", comment: "")
let INIT_TASK_7_DESC = NSLocalizedString("目标是松鼠计划的核心。目标下还有为了实现目标而要完成的任务。完成目标时，可以得到额外的坚果奖励！\n\n一个目标应该有一个明确的达成条件，以便于你判断目标是否达成了。\n\n点击目标列表页面右下角的“+”按钮，就可以创建目标了！", comment: "")

let INIT_REWARD_1_TITLE = NSLocalizedString("解锁松鼠日历", comment: "初始奖项：解锁松鼠日历")

