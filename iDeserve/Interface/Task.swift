//
//  Task.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/9/30.
//

import Foundation

struct Task: Hashable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var done: Bool = false
    //    分值
    var value: Int
    //    重复频率
    var repeatFrequency: RepeatFrequency = RepeatFrequency.never
    //    重要任务
    var starred: Bool = false
    //    截止时间
    var ddl: Date?
    //    描述
    var desc: String = ""
    //    父任务 id
    var parent: String?
}
