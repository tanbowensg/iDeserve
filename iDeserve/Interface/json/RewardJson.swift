//
//  RewardJson.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/24.
//

import Foundation
import CoreData

struct RewardJson: Codable {
    var name: String
    var type: String
    var value: Int16
    var isSoldout: Bool
    var isRepeat: Bool
    var createdTime: Date
    
    init(r: Reward) {
        name = r.name!
        type = r.type!
        value = r.value
        isSoldout = r.isSoldout
        isRepeat = r.isRepeat
        createdTime = r.createdTime!
    }
}

func importRewardJson(rewardJson: RewardJson) -> Reward {
    let r = Reward(context: CoreDataContainer.shared.context)
    r.id = UUID()
    r.name = rewardJson.name
    r.type = rewardJson.type
    r.value = rewardJson.value
    r.isSoldout = rewardJson.isSoldout
    r.isRepeat = rewardJson.isRepeat
    r.createdTime = rewardJson.createdTime
    return r
}
