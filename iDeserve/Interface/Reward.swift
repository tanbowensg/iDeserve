//
//  Reward.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/9/30.
//

import Foundation

struct Reward: Hashable, Identifiable {
    var id = UUID().uuidString
    var name: String
    //    分值
    var value: Int
    //    封面图片
    var cover: String
    //    重复频率
    var repeatFrequency: RepeatFrequency = RepeatFrequency.never
    //    介绍
    var desc: String = ""
    //    已兑换完
    var isSoldout: Bool = false
}
