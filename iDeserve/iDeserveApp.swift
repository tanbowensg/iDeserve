//
//  iDeserveApp.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/9/30.
//

import SwiftUI
import CoreData

//重置任务完成状态的定时任务
func resetTaskStatus () {
    let moc = GlobalStore.shared.moc
    let taskRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
    
    do {
        let fetchedTasks = try moc.fetch(taskRequest) as! [Task]
        fetchedTasks.forEach {task in
            if (task.done && task.completeTimes < task.repeatTimes) {
                task.done = false
            }
        }
        try moc.save()
    } catch {
        print("执行任务状态重置")
    }
}

@main
struct iDeserveApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        
        WindowGroup {
            ZStack {
                    Color.bg
                        .ignoresSafeArea()
                    Tab()
                        .environment(\.managedObjectContext, GlobalStore.shared.moc)
                        .environmentObject(GlobalStore.shared)
                        .environmentObject(PointsStore.shared)
            }
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .active:
                    resetTaskStatus()
                default:
                    print(phase)
            }
        }
    }
}
