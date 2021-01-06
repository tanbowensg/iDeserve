//
//  resetGoalPos.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/7.
//

import Foundation
import CoreData

// 重置目标的pos值
func resetGoalPos () {
    let moc = GlobalStore.shared.moc
    let goalRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Goal")
    goalRequest.sortDescriptors = [
        NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
    ]
    
    do {
        let fetchedGoals = try moc.fetch(goalRequest) as! [Goal]
        fetchedGoals.indices.forEach {i in
            fetchedGoals[i].pos = Int16((i + 1) * MAX_POS / fetchedGoals.count)
        }
        try moc.save()
    } catch {
        print("重置目标的pos值失败")
    }
}

// 重置奖励的pos值
func resetRewardPos () {
    let moc = GlobalStore.shared.moc
    let rewardRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Reward")
    rewardRequest.sortDescriptors = [
        NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
    ]
    
    do {
        let fetchedRewards = try moc.fetch(rewardRequest) as! [Reward]
        fetchedRewards.indices.forEach {i in
            fetchedRewards[i].pos = Int16((i + 1) * MAX_POS / fetchedRewards.count)
        }
        try moc.save()
    } catch {
        print("重置奖励的pos值失败")
    }
}
