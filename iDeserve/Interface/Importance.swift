//
//  Importance.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/8.
//

import Foundation
import SwiftUI

enum Importance: Int, CaseIterable {
    case normal = 1
    case important = 2
    case epic = 3
}

let ImportanceColor: [Importance: Color] = [
    .normal: Color.darkBrandGreen,
    .important: Color.rewardColor,
    .epic: Color.init("epicRed")
]

func getImportanceValue (_ value: Importance) -> Int {
    switch value {
    case Importance.normal:
        return 100
    case Importance.important:
        return 200
    case Importance.epic:
        return 400
    }
}
