//
//  RewardStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/9.
//

import Foundation
import SwiftUI
import CoreData

final class RewardStore: ObservableObject {
    var moc = CoreDataContainer.shared.context
    static var shared = RewardStore()
    private var recordStore = RecordStore.shared
    private var pointsStore = PointsStore.shared

    func updateReward (
        targetReward: Reward,
        name: String,
        type: RewardType,
        value: Int,
        isRepeat: Bool
    ) {
        targetReward.name = name
        targetReward.type = type.rawValue
        targetReward.value = Int16(value)
        targetReward.isRepeat = isRepeat
        
//        如果奖励从一次性变成可重复，那就要重置isSoldout
        if !targetReward.isRepeat && isRepeat {
            targetReward.isSoldout = true
        }

        do {
            try self.moc.save()
        } catch let error  {
            print(error)
            fatalError("更新奖励到 coredata中失败")
        }
    }

    func createReward (
        name: String,
        type: RewardType,
        value: Int,
        isRepeat: Bool
    ) {
        let newReward = Reward(context: self.moc)
        newReward.id = UUID()
        newReward.createdTime = Date()

        self.updateReward(
            targetReward: newReward,
            name: name,
            type: type,
            value: value,
            isRepeat: isRepeat
        )
    }
    
    func redeemReward (_ reward: Reward) {
        reward.isSoldout = true
//        扣钱
        self.pointsStore.minus(Int(reward.value))
//      插入完成记录
        self.recordStore.createRecord(name: reward.name!, kind: .reward, value: Int(reward.value))

        do {
            try self.moc.save()
        } catch {
            print("兑换奖励失败")
        }
        
    }
    
    func removeReward(_ reward: Reward) {
        self.moc.delete(reward)
    }
}
