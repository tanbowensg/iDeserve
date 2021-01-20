//
//  Difficulty.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import Foundation

enum Difficulty: Int, CaseIterable {
    case easy = 10
    case medium = 20
    case hard = 40
}

let DIFFICULTY_EASY_TEXT = NSLocalizedString("容易", comment: "")
let DIFFICULTY_MEDIUM_TEXT = NSLocalizedString("普通", comment: "")
let DIFFICULTY_HARD_TEXT = NSLocalizedString("挑战", comment: "")

func getDifficultyText (_ value: Difficulty) -> String {
    switch value {
    case Difficulty.easy:
        return DIFFICULTY_EASY_TEXT
    case Difficulty.medium:
        return DIFFICULTY_MEDIUM_TEXT
    case Difficulty.hard:
        return DIFFICULTY_HARD_TEXT
    }
}
