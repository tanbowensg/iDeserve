//
//  TaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData

struct TaskPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore

    @FetchRequest(fetchRequest: goalRequest) var goals: FetchedResults<Goal>
    
//    为了在任务更新的时候重新渲染目标
//    https://stackoverflow.com/questions/58643094/how-to-update-fetchrequest-when-a-related-entity-changes-in-swiftui
    @State private var refreshing = false
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    static var goalRequest: NSFetchRequest<Goal> {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = []
        return request
   }

    var body: some View {
        NavigationView() {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    ForEach (goals, id: \.id) { goal in
                        GoalRow(
                            goal: goal,
                            onCompleteTask: { task in
                                gs.taskStore.completeTask(task)
                            },
                            onRemoveTask: { task in
                                gs.taskStore.removeTask(task)
                            }
                        )
                    }
//                    无用，纯粹为了在任务更新时刷新目标列表
                    Text(self.refreshing ? "" : "")
                }
                    .onReceive(self.didSave) { _ in
                        self.refreshing.toggle()
                    }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: EditTaskPage(originTask: nil)) {
                            CreateButton()
                        }
                        NavigationLink(destination: EditGoalPage(initGoal: nil)) {
                            CreateButton()
                        }
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 16)
            }
                .navigationBarHidden(true)
        }
    }
}

struct TaskPage_Previews: PreviewProvider {
    static var previews: some View {
        TaskPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
