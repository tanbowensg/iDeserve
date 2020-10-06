//
//  TasksStore.swift
//  TodoDemo
//
//  Created by 谈博文 on 2020/8/24.
//  Copyright © 2020 瞬光工作室. All rights reserved.
//

import Combine
import SwiftUI

let DefaultTasks: [Task] = [
    Task(name: "学习 SwiftUI", value: 100, starred: true, desc: "要做出 iDeserve 才行"),
    Task(name: "制定敦煌行程", done: true, value: 5, ddl: Date()),
    Task(name: "制作一档博客", value: 80, repeatFrequency: RepeatFrequency.weekly),
    Task(name: "读完《独裁者手册》", value: 77, repeatFrequency: RepeatFrequency.monthly, starred: true, ddl: Date()),
    Task(name: "写完圣农发展研报", done: true, value: 48),
]

final class TasksStore: ObservableObject {
    @Published var tasks: [Task] = DefaultTasks
    
    func createTask (name: String, value: Int) {
        let newTask = Task(id: UUID().uuidString, name: name, value: value)
        self.tasks += [newTask]
    }
    
    func deleteTask (id: String) {
        self.tasks.removeAll{ $0.id == id }
    }

    // 切换任务完成状态
    func toggleTaskDone (id: String) {
        let index = self.tasks.firstIndex(where: { $0.id == id })!
        self.tasks[index].done.toggle()
    }
    
    // 修改任务标题
    func changeTaskName (id: String, newName: String) {
        let index = self.tasks.firstIndex(where: { $0.id == id })!
        self.tasks[index].name = newName
    }
}
