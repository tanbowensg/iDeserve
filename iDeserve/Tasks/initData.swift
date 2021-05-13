//
//  initData.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/12.
//

import Foundation
import CoreData

func genTaskState(
    name: String,
    desc: String = "",
    repeatFrequency: RepeatFrequency = .never,
    repeatTimes: Int = 1,
    hasDdl: Bool = false,
    ddl: Date = Date(),
    starred: Bool = false,
    timeCost: Int = 1,
    difficulty: Difficulty = .easy
) -> TaskState {
    var ts = TaskState(name: name)
    ts.desc = desc
    ts.repeatFrequency = repeatFrequency
    ts.repeatTimes = repeatTimes
    ts.hasDdl = hasDdl
    ts.ddl = ddl
    ts.starred = starred
    ts.timeCost = timeCost
    ts.difficulty = difficulty
    return ts
}

func initData () -> Void {
    let defaults = UserDefaults.standard
    let hasInited = defaults.bool(forKey: HAS_INITED)
    
    if hasInited {
        return
    }
    initReward()
    initGoal()
    initUserDefaults()
    defaults.setValue(true, forKey: HAS_INITED)
}

func initUserDefaults () -> Void {
    let defaults = UserDefaults.standard
    defaults.set(true, forKey: FIRST_RECORDS)
    defaults.set(true, forKey: FIRST_REWARD_STORE)
    defaults.set(true, forKey: FIRST_MYDAY)
    defaults.set(true, forKey: FIRST_GOAL_LIST)
}

func initReward () -> Void {
    GlobalStore.shared.rewardStore.createReward(
        name: INIT_REWARD_2_TITLE,
        type: .drink,
        value: 30,
        isRepeat: true,
        desc: "",
        cover: nil
    )
    GlobalStore.shared.rewardStore.createReward(
        name: INIT_REWARD_3_TITLE,
        type: .digital,
        value: 1000,
        isRepeat: false,
        desc: "",
        cover: nil
    )
    GlobalStore.shared.rewardStore.createReward(
        name: INIT_REWARD_4_TITLE,
        type: .game,
        value: 20,
        isRepeat: true,
        desc: "",
        cover: nil
    )
    GlobalStore.shared.rewardStore.createReward(
        name: INIT_REWARD_5_TITLE,
        type: .travel,
        value: 3500,
        isRepeat: false,
        desc: "",
        cover: nil
    )
}

func initGoal () -> Void {
    let tasks = [
        genTaskState(name: INIT_TASK_0_TITLE, desc: INIT_TASK_0_DESC, starred: true),
        genTaskState(name: INIT_TASK_1_TITLE, desc: INIT_TASK_1_DESC, starred: true),
        genTaskState(name: INIT_TASK_2_TITLE, desc: INIT_TASK_2_DESC, starred: true),
        genTaskState(name: INIT_TASK_3_TITLE, desc: INIT_TASK_3_DESC, hasDdl: true),
        genTaskState(name: INIT_TASK_4_TITLE, desc: INIT_TASK_4_DESC, repeatFrequency: .unlimited, repeatTimes: 5),
        genTaskState(name: INIT_TASK_5_TITLE, desc: INIT_TASK_5_DESC, starred: true),
        genTaskState(name: INIT_TASK_6_TITLE, desc: INIT_TASK_6_DESC, starred: true),
        genTaskState(name: INIT_TASK_7_TITLE, desc: INIT_TASK_7_DESC, starred: true)
    ]
    
    GlobalStore.shared.goalStore.createGoal(
        name: INIT_GOAL_TITLE,
        type: .hobby,
        importance: .normal,
        desc: "",
        tasks: tasks
    )
}
