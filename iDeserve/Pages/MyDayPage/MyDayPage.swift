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
    @AppStorage(FIRST_MYDAY) var isFirstVisitPage = false
    @State var offsetY: Double = 0
    @State var shouldOpenSheet = false
    @State var currentTask: Task?
    @State var isShowLanding: Bool = false
    @FetchRequest(fetchRequest: taskRequest) var allTasks: FetchedResults<Task>
    
    let safeAreaHeight: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)!
    
    let scrollThreshold = 100

    static var taskRequest: NSFetchRequest<Task> {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    var myDayTasks: [Task] {
        Array(allTasks)
//        return filterMyDayTask(allTasks)
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
                        shouldOpenSheet = true
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
                        shouldOpenSheet = true
                    }) {
                        TaskItem(
                            task: TaskState(task),
                            onCompleteTask: {
                                withAnimation {
                                    self.gs.taskStore.completeTask(task)
                                }
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
        VStack(alignment: .center, spacing: 25) {
            Spacer()
            Image("cabin")
                .resizable()
                .frame(width: 200, height: 200)
            Text("今天没有要做的事情！\n去奖励商店里好好犒赏自己吧！")
                .font(.bodyCustom)
                .foregroundColor(.b3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .lineSpacing(8)
            Spacer()
        }
        .padding(.top, 60)
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            ZStack(alignment: .top) {
                Image("headerBg")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width)
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
                isShowLanding ? PopupMask() : nil
            }
            //                用来修复第一次点开sheet没有内容的bug
            currentTask == nil ? Group{} : nil
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .sheet(isPresented: $shouldOpenSheet, content: {
            MyDayCreateTaskSheet(task: currentTask)
        })
        .popup(isPresented: $isShowLanding, type: .default, closeOnTap: false, closeOnTapOutside: false, dismissCallback: { isFirstVisitPage = false }) {
            HelpTextModal(isShow: $isShowLanding, title: "今日任务介绍", text: FIRST_MYDAY_TEXT)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isShowLanding = isFirstVisitPage
            }
        }
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
