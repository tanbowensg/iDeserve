//
//  EditGoalPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct EditGoalPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var initGoal: Goal?

    @State var name: String = ""
    @State var importance: Importance = Importance.normal
    @State var desc = ""
    @State var tasks: [TaskState] = []

    @State var taskCache: TaskState = TaskState(nil)
    
    @State var isShowImportancePicker = false
    @State var isShowTaskSheet = false

    init (initGoal: Goal?) {
        self.initGoal = initGoal
        if let existGoal = initGoal {
            _name = State(initialValue: existGoal.name ?? "")
            _importance = State(initialValue: Importance(rawValue: Int(existGoal.importance)) ?? Importance.normal)
            _desc = State(initialValue: existGoal.desc ?? "")
            if let existTasks = existGoal.tasks {
                let tasksArray = existTasks.allObjects as! [Task]
                let taskStates = tasksArray
                    .map {task in
                        return TaskState(task)
                    }
                _tasks = State(initialValue: taskStates)
            }
        }
    }

    var goalTitle: some View {
        Group {
            TextField("目标标题", text: $name)
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20.0)
                .frame(height: 40)
            Divider()
        }
    }

    var goalImportance: some View {
        Button(action: {
            isShowImportancePicker.toggle()
        }) {
            FormItem(
                icon: Image(systemName: "lightbulb"),
                name: "重要性",
                valueView: Text(getImportanceText(importance))
            )
        }
    }
    
//    重要性选择器
    var importancePicker: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowImportancePicker.toggle()
//                tempTask = Task()
            }) {
                Text("完成")
            }
                .padding(8)
            Picker("难度", selection: $importance) {
                ForEach(Importance.allCases, id: \.self) {importanceOption in
                    Text(getImportanceText(importanceOption)).tag(importanceOption)
                }
                .labelsHidden()
            }
        }
            .background(Color.g10)
    }
    
    var createTaskButton: some View {
        Button(action: {
            isShowTaskSheet.toggle()
            taskCache = TaskState(nil)
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
            .sheet(isPresented: $isShowTaskSheet, onDismiss: addTask, content: {
                GoalTasksSheet(taskState: $taskCache)
            })
    }
    
//    目标的任务
    var goalTasks: some View {
        Group {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("任务").font(.hiraginoSansGb16)
                    Spacer()
                    createTaskButton
                }
                    .padding(.horizontal, 20.0)
                    .padding(.vertical, 16.0)
                HStack(spacing: 0) {
                    Text("共计 \(tasks.count) 个任务，全部完成可得")
                        .foregroundColor(.g60)
                    NutIcon(value: 100)
                }
                    .font(.hiraginoSansGb12)
                    .padding(.horizontal, 20.0)
//                    .padding(.vertical, 8.0)
                ForEach (tasks, id: \.id) { task in
                    Button(action: {
                        taskCache = task
                        isShowTaskSheet.toggle()
                    }) {
                        TaskItem(task: task)
                    }
                }
            }
            Divider()
        }
    }

    var backBtn: some View {
        Button(action: {
            self.saveGoal()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .padding(.leading, 16.0)
                Text("目标列表")
                
            }
            .frame(height: 30)
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    backBtn
                    goalTitle
                    goalImportance
                    HStack() {
                        TextField("备注", text: $desc)
                            .padding(.horizontal, 20.0)
                            .padding(.vertical, 16.0)
                            .font(.hiraginoSansGb14)
                    }
                    Divider()
                    goalTasks
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
            Popup(isVisible: isShowImportancePicker, content: importancePicker)
        }
        .navigationBarHidden(true)
    }
    
    func addTask () {
        if (taskCache.name == "") {
            return
        }

        let targetTaskIndex = tasks.firstIndex { item in
            return item.id.uuidString == taskCache.id.uuidString
        }

        if let index = targetTaskIndex {
            print("更新任务")
            print(taskCache)
            tasks[index] = taskCache
        } else {
            print("创建新任务")
            tasks.append(taskCache)
        }
    }

    func saveTask () {
        print(taskCache)
    }
    
    func saveGoal () {
        if name == "" {
            return
        }
        print(tasks)
        if initGoal?.id != nil {
//            id存在就更新
            gs.goalStore.updateGoal(
                targetGoal: initGoal!,
                name: name,
                importance: importance,
                desc: desc,
                tasks: tasks
            )
        } else {
//            id不存在就创建
            gs.goalStore.createGoal(
                name: name,
                importance: importance,
                desc: desc,
                tasks: tasks
            )
        }
    }
}

struct EditGoalPage_Previews: PreviewProvider {
    static var previews: some View {
        EditGoalPage(initGoal: nil)
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
