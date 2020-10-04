//
//  Reward.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/9/30.
//

import Foundation

struct Reward: Hashable, Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    //    分值
    var value: Int
    //    封面图片
    var cover: String
    //    可重复兑换
    var repeatable: Bool
    //    已兑换完
    var isSoldout: Bool
}
