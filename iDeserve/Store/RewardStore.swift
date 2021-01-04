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
        value: Int,
        repeatFrequency: RepeatFrequency,
        desc: String,
        isSoldout: Bool,
        cover: Data?
    ) {
        targetReward.name = name
        targetReward.value = Int16(value)
        targetReward.repeatFrequency = Int16(repeatFrequency.rawValue)
        targetReward.desc = desc
        targetReward.isSoldout = isSoldout
        targetReward.cover = cover
        
    
        do {
            try self.moc.save()
        } catch let error  {
            print(error)
            fatalError("更新奖励到 coredata中失败")
        }
    }

    func createReward (
        name: String,
        value: Int,
        repeatFrequency: RepeatFrequency,
        desc: String,
        isSoldout: Bool,
        cover: Data?
    ) {
        let newReward = Reward(context: self.moc)
        newReward.id = UUID()

        self.updateReward(
            targetReward: newReward,
            name: name,
            value: value,
            repeatFrequency: repeatFrequency,
            desc: desc,
            isSoldout: isSoldout,
            cover: cover
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
