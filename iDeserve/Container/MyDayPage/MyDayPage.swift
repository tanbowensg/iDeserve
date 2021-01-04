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
        print(offsetY)
        if (offsetY >= Double(scrollThreshold)) {
            shouldOpenSheet = true
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Text("下拉创建任务")
                .opacity(Double(offsetY / 100))
                .sheet(isPresented: $shouldOpenSheet, content: {
                    MyDayCreateTaskSheet()
                })
            CustomScrollView(showsIndicators: true, onOffsetChange: onOffsetChange) {
//               TODO：这里不能使用 lazyVstack，否则在模拟器里滚动会闪烁，原因不明
                VStack(alignment: .leading) {
                    ForEach (uncompletedTasks, id: \.id) { task in
                        TaskItem(
                            task: TaskState(task),
                            onCompleteTask: {
                                self.gs.taskStore.completeTask(task)
                            }
//                            onRemoveTask: {
//                                self.gs.taskStore.removeTask(task)
//                            }
                        )
                    }
                    ForEach (completedTasks, id: \.id) { task in
                        TaskItem(
                            task: TaskState(task)
                        )
                    }
                    Text("").frame(maxWidth: .infinity)
                    Spacer()
                }
                    .animation(.easeInOut)
            }
        }
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
