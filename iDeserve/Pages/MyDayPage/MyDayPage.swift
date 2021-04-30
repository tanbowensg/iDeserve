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
    @State var currentTask: Task?
    @FetchRequest(fetchRequest: taskRequest) var allTasks: FetchedResults<Task>
    
    let safeAreaHeight: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)!
    
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
            .foregroundColor(.b2)
            .padding(.vertical, 20.0)
    }
    
    var completedTasksView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("今天完成的任务")
                .font(.subheadCustom)
                .foregroundColor(.b3)
                .fontWeight(.bold)
                .padding(.leading, 25)
            ForEach (completedTasks, id: \.id) { task in
                VStack(spacing: 0.0) {
                    Button(action: {
                        currentTask = task
                    }) {
                        TaskItem(task: TaskState(task))
                    }
                    ExDivider().padding(.horizontal, 25)
                }
            }
        }
        .padding(.top, 12)
    }
    
    var taskList: some View {
//      TODO：这里不能使用 lazyVstack，否则在模拟器里滚动会闪烁，原因不明
        VStack(alignment: .leading, spacing: 0) {
            ForEach (uncompletedTasks, id: \.id) { task in
                VStack(spacing: 0.0) {
                    Button(action: {
                        currentTask = task
                    }) {
                        TaskItem(
                            task: TaskState(task),
                            onCompleteTask: {
                                self.gs.taskStore.completeTask(task)
                            }
                        )
                    }
                    ExDivider().padding(.horizontal, 25)
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
            Text("今天没有要做的事情哦！\n你可以下拉界面创建任务，\n或者把想做的任务添加到今日任务里！")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity)
                .lineSpacing(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
            Spacer()
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("headerBg")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width)
                .ignoresSafeArea()
            VStack(spacing: 0.0){
                AppHeader(title: "今日任务", image: "squirrel")
                CustomScrollView(showsIndicators: false) {
                    VStack {
                        if myDayTasks.count == 0 {
                            emptyState
                        } else {
                            taskList
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
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
