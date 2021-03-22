//
//  filterMyDayTasks.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/16.
//

import Foundation
import SwiftUI

let ddlThreshold = 7 * 24 * 3600

// 过滤出需要显示在我的一天中的任务
// 目标已经完成的任务不显示
// 1. 重复到今天的
// 2. 一周内快要截止的
// 3. 用户自己设置的
func filterMyDayTask (_ tasks: FetchedResults<Task>) -> [Task] {
    return tasks.filter({(task: Task) in
        return task.parent?.done == false
            && ( task.starred
                || task.repeatFrequency != RepeatFrequency.never.rawValue
                || (task.ddl != nil && Int(task.ddl!.timeIntervalSinceNow) < ddlThreshold
            )
        )
    })
}

