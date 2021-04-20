//
//  Difficulty.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import Foundation
import SwiftUI

enum Difficulty: Int, CaseIterable {
    case easy = 10
    case medium = 20
    case hard = 40
}

let DifficultyColor: [Difficulty: Color] = [
    .easy: Color.customGreen,
    .medium: Color.customBlue,
    .hard: Color.customRed
]
