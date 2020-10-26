//
//  TaskState.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import Foundation

struct TaskState: Hashable, Identifiable {
    var id = UUID()
    var name: String = ""
    var value: String = "0"
    var repeatFrequency: RepeatFrequency = .never
    var hasDdl: Bool = false
    var ddl: Date = Date()
    var desc: String = ""

    init (initTask: Task?) {
        if let existTask = initTask {
            name = existTask.name ?? ""
            value = String(existTask.value)
            repeatFrequency = RepeatFrequency(rawValue: Int(existTask.repeatFrequency)) ?? .never
            hasDdl = existTask.ddl != nil
            desc = existTask.desc ?? ""
            
            if let existDdl = existTask.ddl {
                ddl = existDdl
            }
        }
    }
}
