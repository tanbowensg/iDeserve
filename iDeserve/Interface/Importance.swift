//
//  Importance.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/8.
//

import Foundation

enum Importance: Int, CaseIterable {
    case normal = 1
    case important = 2
    case epic = 3
}

let IMPORTANCE_NORMAL_TEXT = NSLocalizedString("普通", comment: "")
let IMPORTANCE_IMPORTANT_TEXT = NSLocalizedString("重要", comment: "")
let IMPORTANCE_EPIC_TEXT = NSLocalizedString("史诗", comment: "")

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
