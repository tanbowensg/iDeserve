//
//  Reward.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/3.
//

import Foundation
import SwiftUI

extension Reward {
    var isAvailable: Bool {
        return self.isRepeat || !self.isSoldout
    }
}

enum RewardType: String, CaseIterable {
    case food = "gluttony"
    case rest = "sloth"
    case shopping = "greed"
    case entertainment = "entertainment"
    case travel = "travel"
    case system = "system"
}

let rewardGoldMap: [RewardType: Color] = [
    .entertainment: Color.orange,
    .food: Color.yellow,
    .travel: Color.blue,
    .rest: Color.green,
    .shopping: Color.red,
    .system: Color.g60
]

let RewardIconMap: [RewardType: String] = [
    .entertainment: "gamecontroller",
    .food: "hare",
    .travel: "airplane",
    .rest: "bed.double",
    .shopping: "bag",
    .system: "gear"
]
