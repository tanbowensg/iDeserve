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
    @State var showBonusToast = false
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
//        必须是今天完成的任务才算
        myDayTasks.filter {
            return $0.done
                && $0.lastCompleteTime != nil
                && Calendar.current.isDate(Date(), inSameDayAs:$0.lastCompleteTime!)
        }
    }
    
    var uncompletedTasks: [Task] {
        myDayTasks.filter{ return !$0.done }
    }
    
    func header(_ text: String) -> some View {
        Text(text)
            .font(.subheadCustom)
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
    
    var completedTasksView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text("今天完成的任务")
                .font(.subheadCustom)
                .padding(.leading, 32.0)
            ForEach (completedTasks, id: \.id) { task in
                Button(action: {
                    currentTask = task
                    shouldOpenSheet = true
                }) {
                    TaskItem(task: TaskState(task))
                }
            }
        }
    }
    
    var taskList: some View {
//      TODO：这里不能使用 lazyVstack，否则在模拟器里滚动会闪烁，原因不明
        VStack(alignment: .leading, spacing: 12.0) {
            ForEach (uncompletedTasks, id: \.id) { task in
                Button(action: {
                    currentTask = task
                    shouldOpenSheet = true
                }) {
                    TaskItem(
                        task: TaskState(task),
                        onCompleteTask: {
                            self.gs.taskStore.completeTask(task)
                            showBonusToast.toggle()
                        }
                    )
                }
            }
            completedTasks.count > 0 ? completedTasksView : nil
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
            .popup(isPresented: $showBonusToast, type: .toast, position: .top, autohideIn: 3, closeOnTap: true, closeOnTapOutside: true, view: {
                Text("在DDL前完成了任务，额外奖励3个坚果！")
                    .padding(16)
                    .background(Color.g10.cornerRadius(15))
                    .padding(20)
            })
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
