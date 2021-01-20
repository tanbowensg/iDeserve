//
//  MyDayPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/12.
//

import SwiftUI
import CoreData

struct MyDayPage: View {
    @EnvironmentObject var gs: GlobalStore
    @State var offsetY: Double = 0
    @State var shouldOpenSheet = false
    @State var currentTask: Task?
    @FetchRequest(fetchRequest: taskRequest) var allTasks: FetchedResults<Task>
    
    let scrollThreshold = 100

    static var taskRequest: NSFetchRequest<Task> {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    var myDayTasks: [Task] {
        return filterMyDayTask(allTasks)
    }
    
    var completedTasks: [Task] {
        myDayTasks.filter{ return $0.done }
    }
    
    var uncompletedTasks: [Task] {
        myDayTasks.filter{ return !$0.done }
    }
    
    func header(_ text: String) -> some View {
        Text(text)
            .font(.hiraginoSansGb14)
            .fontWeight(.bold)
            .padding(.leading, 30.0)
            .foregroundColor(.myBlack)
            .padding(.vertical, 20.0)
    }
    
    func onOffsetChange (_ offset: CGFloat) -> Void {
        offsetY = Double(offset)
        if (offsetY >= Double(scrollThreshold)) {
            shouldOpenSheet = true
            currentTask = nil
        }
    }
    
    var taskList: some View {
//      TODO：这里不能使用 lazyVstack，否则在模拟器里滚动会闪烁，原因不明
        VStack(alignment: .leading) {
            ForEach (uncompletedTasks, id: \.id) { task in
                Button(action: {
                    currentTask = task
                    shouldOpenSheet = true
                }) {
                    TaskItem(
                        task: TaskState(task),
                        onCompleteTask: {
                            self.gs.taskStore.completeTask(task)
                        }
                    )
                }
            }
            ForEach (completedTasks, id: \.id) { task in
                Button(action: {
                    currentTask = task
                    shouldOpenSheet = true
                }) {
                    TaskItem(task: TaskState(task))
                }
            }
            Text("").frame(maxWidth: .infinity)
            Spacer()
        }
    }
    
    var emptyState: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("今天没有要做的事情哦！\n你可以下拉界面创建任务，\n或者把想做的任务添加到我的一天里！")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32.0)
                .frame(maxWidth: .infinity)
                .lineSpacing(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
            Spacer()
        }
    }

    var body: some View {
        VStack(spacing: 0.0) {
            AppHeader(points: gs.pointsStore.points, title: "我的一天")
            ZStack(alignment: .top) {
                Text("下拉创建任务")
                    .opacity(Double(offsetY / 100))
                CustomScrollView(showsIndicators: true, onOffsetChange: onOffsetChange) {
                    if myDayTasks.count == 0 {
                        emptyState
                    } else {
                        taskList
                    }
                }
//                用来修复第一次点开sheet没有内容的bug
                currentTask == nil ? Text("") : nil
            }
        }
        .sheet(isPresented: $shouldOpenSheet, content: {
            MyDayCreateTaskSheet(task: currentTask)
        })
        .navigationBarHidden(true)
    }
}

struct MyDayPage_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataContainer.shared.context
        let _ = genMockTasks(context)
        MyDayPage()
            .environment(\.managedObjectContext, context)
            .environmentObject(GlobalStore.shared)
    }
}
