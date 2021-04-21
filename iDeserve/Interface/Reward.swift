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
    case food = "food"
    case rest = "rest"
    case shopping = "shopping"
    case entertainment = "entertainment"
    case travel = "travel"
    case game = "game"
    case drink = "drink"
    case digital = "digital"
    case movie = "movie"
    case system = "system"
}
