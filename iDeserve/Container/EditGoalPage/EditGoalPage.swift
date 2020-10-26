//
//  EditGoalPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct EditGoalPage: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var initGoal: Goal?

    @State var name: String = ""
    @State var difficulty: Difficulty = Difficulty.easy
    @State var desc = ""
    @State var tasks: [TaskState] = []

    @State var taskCache: TaskState = TaskState(originTask: nil)
    
    @State var isShowDifficultyPicker = false
    @State var isShowTaskSheet = false

    init (initGoal: Goal?) {
        self.initGoal = initGoal
        if let existGoal = initGoal {
            _name = State(initialValue: existGoal.name ?? "")
            _difficulty = State(initialValue: Difficulty(rawValue: Int(existGoal.difficulty)) ?? Difficulty.easy)
            _desc = State(initialValue: existGoal.desc ?? "")
//            if (existGoal.tasks != nil) {
//                _tasks = State(initialValue: existGoal.tasks!.allObjects as! [Task])
//            }
        }
    }

    var goalTitle: some View {
        Group {
            TextField("目标标题", text: $name)
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16.0)
            Divider()
        }
    }

    var goalValue: some View {
        Group {
            HStack() {
                Image(systemName: "dollarsign.circle")
                Text("分值")
                Spacer()
                Text("100")
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
                .padding(.horizontal, 16.0)
            Divider()
        }
    }

    var goalDifficulty: some View {
        Group {
            Button(action: {
                isShowDifficultyPicker.toggle()
            }) {
                HStack() {
                    Image(systemName: "repeat")
                    Text("难度")
                    Spacer()
                    Text(getDifficultyText(difficulty))
                }
                    .padding(.horizontal, 16.0)
                    .foregroundColor(.g80)
            }
            Divider()
        }
    }
    
//    难度选择器
    var difficultyPicker: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowDifficultyPicker.toggle()
//                tempTask = Task()
            }) {
                Text("完成")
            }
                .padding(8)
            Picker("难度", selection: $difficulty) {
                ForEach(Difficulty.allCases, id: \.self) {difficultyOption in
                    Text(getDifficultyText(difficultyOption)).tag(difficultyOption)
                }
                .labelsHidden()
            }
        }
            .background(Color.g10)
    }
    
//    目标的任务
    var goalTasks: some View {
        Group {
            VStack(alignment: .leading) {
                Text("任务")
                    .font(.headline)
                    .padding(.horizontal, 16.0)
                Button(action: {
                    isShowTaskSheet.toggle()
                    taskCache = TaskState(originTask: nil)
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("添加任务")
                    }
                }
                    .sheet(isPresented: $isShowTaskSheet, onDismiss: addTask, content: {
                        GoalTasksSheet(taskState: $taskCache)
                    })
                List {
                    ForEach (tasks, id: \.id) { task in
                        Text(task.name)
//                        TaskRow(task: task.toModel())
//                        TaskRow(task: task.toModel())
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
                    
                Text("返回")
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                backBtn
                goalTitle
                goalValue
                goalDifficulty
                HStack() {
                    TextField("备注", text: $desc)
                        .padding(.horizontal, 16.0)
                }
                goalTasks
            }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .navigationBarHidden(true)
            Popup(isVisible: isShowDifficultyPicker, content: difficultyPicker)
        }
    }
    
    func addTask () {
        print(taskCache)
        if (taskCache.name != "") {
            tasks.append(taskCache)
        }
    }
    
    func saveTask () {
        print("保存任务了")
        print(taskCache)
    }
    
    func saveGoal () {
        print("saveGoal")
        print(name)
        if name == "" {
            return
        }

        if initGoal?.id != nil {
            updateGoal()
        } else {
            createGoal()
        }
    }
    
    func updateGoal () {
        let targetGoal = initGoal!
        targetGoal.name = name
        targetGoal.difficulty = Int16(difficulty.rawValue)
        targetGoal.desc = desc

        do {
            try self.moc.save()
        } catch {
            fatalError("更新任务到 coredata中失败")
        }
    }
    
    func createGoal () {
        print("createGoal")
        let newGoal = Goal(context: self.moc)
        newGoal.id = UUID()
        newGoal.name = name
        newGoal.difficulty = Int16(difficulty.rawValue)
        newGoal.desc = desc

        do {
            try self.moc.save()
        } catch {
            fatalError("创建任务到 coredata中失败")
        }
    }
}

struct EditGoalPage_Previews: PreviewProvider {
    static var previews: some View {
        EditGoalPage(initGoal: nil)
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
