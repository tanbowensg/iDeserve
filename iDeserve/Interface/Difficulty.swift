//
//  Difficulty.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import Foundation

enum Difficulty: Int, CaseIterable {
    case easy = 0
    case medium = 1
    case hard = 2
}

func getDifficultyText (_ value: Difficulty) -> String {
    switch value {
    case Difficulty.easy:
        return "容易"
    case Difficulty.medium:
        return "普通"
    case Difficulty.hard:
        return "挑战"
    }
}
