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
    @State var type: GoalType = GoalType.hobby
    @State var importance: Importance = Importance.normal
    @State var desc = ""
    @State var tasks: [TaskState] = []

    @State var taskCache: TaskState = TaskState(nil)
    
    @State var isShowTypePicker = false
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
                    .sorted{ $0.createdTime ?? Date() < $1.createdTime ?? Date() }
                    .map {task in
                        return TaskState(task)
                    }
                _tasks = State(initialValue: taskStates)
            }
        }
    }
    
    var isCreate: Bool {
        initGoal == nil
    }
    
    var header: some View {
        Group {
            HStack {
                Button(action: {
                    dismissKeyboard()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: isCreate ? "chevron.left" : "xmark")
                        .foregroundColor(.subtitle)
                }
                Spacer()
                Text(isCreate ? "创建新目标" : "修改目标").font(.headlineCustom).foregroundColor(.body)
                Spacer()
                Button(action: {
                    dismissKeyboard()
                    self.saveGoal()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .font(.subheadCustom)
                        .foregroundColor(.brandGreen)
                }
            }
            .padding(.vertical, 20.0)
            .padding(.horizontal, 25.0)
            ExDivider()
        }
    }

    var goalType: some View {
        Button(action: {
            withAnimation {
                dismissKeyboard()
                isShowTypePicker.toggle()
            }
        }) {
            GoalIcon(goalType: type, size: 100)
        }
    }
    
    var goalTitle: some View {
        TextField("目标标题", text: $name)
            .font(.titleCustom)
            .multilineTextAlignment(.center)
    }

    var goalImportance: some View {
        VStack(spacing: 0.0) {
            FormItem(name: "重要性", rightContent: Text(""))
            ImportancePicker(importance: $importance)
                .padding(.bottom, 20.0)
            ExDivider()
        }
    }
    
    var createTaskButton: some View {
        Button(action: {
            dismissKeyboard()
            isShowTaskSheet.toggle()
            taskCache = TaskState(nil)
        }) {
            HStack {
                Spacer()
                Text("添加新的任务")
                    .foregroundColor(.white)
                    .font(.subheadCustom)
                    .frame(height: 16.0)
                    .padding(.vertical, 12.0)
                    .padding(.horizontal, 40.0)
                    .background(Color.brandGreen.cornerRadius(25))
                Spacer()
            }
        }
            .sheet(isPresented: $isShowTaskSheet, onDismiss: { taskCache = TaskState(nil) }, content: {
                GoalTasksSheet(taskState: $taskCache, onSave: addTask)
            })
    }
    
    func taskItem(_ task: TaskState) -> some View {
        let disabledComplete = isCreate || task.done

        func removeTask () {
            withAnimation() {
                tasks.remove(at: tasks.firstIndex(of: task)!)
            }
            if let originalTask = task.originTask {
                gs.taskStore.removeTask(originalTask)
            }
        }

        return Group {
//            编辑目标时，用常规的任务item
            !isCreate ? TaskItem(
                task: task,
                onCompleteTask: disabledComplete ? nil : {
                    if let originalTask = task.originTask {
                        gs.taskStore.completeTask(originalTask)
                        refreshTask()
                    }
                },
                onRemoveTask: removeTask,
                hideTag: true
            ) : nil
//            创建目标时，用简化的任务item
            isCreate ? SimpleTaskItem(
                task: task,
                onRemoveTask: removeTask
            ) : nil
        }
    }
    
//    目标的任务
    var goalTasks: some View {
        let tasksNutsSum = tasks.reduce(0, {(result, task) in
            return result + task.totalValue
        })
        return Group {
            VStack(alignment: .leading, spacing: 20) {
                Text("任务")
                    .font(.subheadCustom)
                    .foregroundColor(.subtitle)
                HStack(spacing: 0) {
                    Text("共计 \(tasks.count) 个任务，全部完成可得")
                    NutIcon(value: tasksNutsSum, hidePlus: true)
                }
                    .foregroundColor(.caption)
                    .font(.caption)
                VStack(spacing: 0.0) {
                    ForEach (tasks, id: \.id) { task in
                        taskItem(task)
                    }
                    createTaskButton
                        .padding(.vertical, 20)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 25)
                .background(Color.white.cornerRadius(25).shadow(color: .lightShadow, radius: 20, x: 0, y: 0))
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0.0) {
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .center, spacing: 20) {
                            goalType
                                .padding(.top, 20)
                            goalTitle
                                .padding(.bottom, 10)
                        }
                        goalImportance
                            .padding(.bottom, 20)
                        goalTasks
                    }
                    .padding(.horizontal, 25)
                }
            }
            isShowTypePicker ? Color.popupMask : nil
        }
        .popup(
            isPresented: $isShowTypePicker,
            type: .floater(verticalPadding: 0),
            position: .bottom,
            animation: .easeOut(duration: 0.3),
            closeOnTap: false,
            closeOnTapOutside: false,
            view: { GoalTypePicker(selectedType: $type, isShow: $isShowTypePicker) }
        )
        .onTapGesture {
            dismissKeyboard()
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
        
        if initGoal != nil {
            saveGoal()
            refreshTask()
        }
    }

//    根据目标数据，刷新task
    func refreshTask () {
        if let existGoal = initGoal {
            if let existTasks = existGoal.tasks {
                let tasksArray = existTasks.allObjects as! [Task]
                let taskStates = tasksArray
                    .map {task in
                        return TaskState(task)
                    }
                tasks = taskStates
            }
        }
    }
    
    func saveGoal () {
        if name == "" {
            return
        }

        if initGoal?.id != nil {
//            id存在就更新
            gs.goalStore.updateGoal(
                targetGoal: initGoal!,
                name: name,
                type: type,
                importance: importance,
                desc: desc,
                tasks: tasks
            )
        } else {
//            id不存在就创建
            gs.goalStore.createGoal(
                name: name,
                type: type,
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
