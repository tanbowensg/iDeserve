//
//  Reward.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/3.
//

import Foundation
import SwiftUI

enum RewardType: String, CaseIterable {
    case food = "gluttony"
    case rest = "sloth"
    case shopping = "greed"
    case entertainment = "entertainment"
    case travel = "travel"
}

let RewardTypeColorMap: [RewardType: Color] = [
    .entertainment: Color.orange,
    .food: Color.yellow,
    .travel: Color.blue,
    .rest: Color.green,
    .shopping: Color.red,
]
