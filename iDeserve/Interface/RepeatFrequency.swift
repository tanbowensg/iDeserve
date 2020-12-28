//
//  RepeatFrequency.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/10.
//

import Foundation

enum RepeatFrequency: Int, CaseIterable {
    case never = 0
    case daily = 1
    case weekly = 2
    case monthly = 3
    case unlimited = 4
    case twoDays = 5
}

let FREQUENCY_NEVER_TEXT = NSLocalizedString("从不", comment: "")
let FREQUENCY_DAILY_TEXT = NSLocalizedString("每天", comment: "")
let FREQUENCY_WEEKLY_TEXT = NSLocalizedString("每周", comment: "")
let FREQUENCY_MONTHLY_TEXT = NSLocalizedString("每月", comment: "")
let FREQUENCY_UNLIMITED_TEXT = NSLocalizedString("无间隔重复", comment: "")
let FREQUENCY_TWODAYS_TEXT = NSLocalizedString("每隔一天", comment: "")

func getRepeatFrequencyText (_ value: RepeatFrequency) -> String {
    switch value {
    case RepeatFrequency.never:
        return FREQUENCY_NEVER_TEXT
    case RepeatFrequency.daily:
        return FREQUENCY_DAILY_TEXT
    case RepeatFrequency.weekly:
        return FREQUENCY_WEEKLY_TEXT
    case RepeatFrequency.monthly:
        return FREQUENCY_MONTHLY_TEXT
    case RepeatFrequency.unlimited:
        return FREQUENCY_UNLIMITED_TEXT
    case RepeatFrequency.twoDays:
        return FREQUENCY_TWODAYS_TEXT
    }
}
