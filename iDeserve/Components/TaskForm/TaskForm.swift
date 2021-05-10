//
//  TaskForm.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI
import Sliders
import CoreData

struct TaskForm: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(fetchRequest: goalRequest) var goals: FetchedResults<Goal>

    @Binding var taskState: TaskState
    var showGoal: Bool = false
    var onTapClose: () -> Void
    var onTapSave: () -> Void
    @State private var speed = 5
    @State var isShowRepeatPicker = false
    @State var isShowDatePicker = false

    static var goalRequest: NSFetchRequest<Goal> {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
        ]
        return request
    }
    
    var isEdit: Bool {
        taskState.originTask != nil
    }
    
    var taskColor: Color {
        DifficultyColor[taskState.difficulty]!
    }
    
    func onAppear () {
        if taskState.goalId == nil && goals.count > 0 {
            taskState.goalId = goals[0].id!
            taskState.goalName = goals[0].name!
        }
    }
    
    var header: some View {
        Group {
            HStack {
                Button(action: { onTapClose() }) {
                    Image(systemName: "xmark")
                        .font(Font.headlineCustom.weight(.bold))
                        .foregroundColor(.b2)
                }
                Spacer()
                Text(isEdit ? "修改任务" : "添加新任务")
                    .font(.headlineCustom)
                    .foregroundColor(.b3)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { onTapSave() }) {
                    Text("保存")
                        .font(.subheadCustom)
                        .foregroundColor(taskColor)
                        .fontWeight(.bold)
                }
            }
            .padding(.vertical, 30.0)
            .padding(.horizontal, 25.0)
            ExDivider()
        }
    }

    var taskTitle: some View {
        Group {
            TextField("在这里输入任务标题", text: $taskState.name)
                .font(Font.titleCustom.weight(.bold))
                .multilineTextAlignment(.leading)
                .padding(.vertical, 20)
            ExDivider()
        }
    }

    var taskGoal: some View {
        let goalMenu = Menu {
            ForEach(goals, id: \.id) {goalOption in
                Button(action: {
                    let targetGoal = goals.first{ $0.id == goalOption.id }
                    taskState.goalName = targetGoal!.name!
                }) {
                    Text(goalOption.name!).font(.bodyCustom)
                }
            }
        } label: {
            HStack(spacing: 20.0) {
                Text(taskState.goalName)
                    .font(.footnoteCustom)
                    .fontWeight(.bold)
                Image(systemName: "chevron.down")
                    .frame(width: 16.0)
            }
            .padding(10)
            .frame(minWidth: 100)
            .frame(height: 32)
            .background(Color.white.cornerRadius(10).shadow(color: .darkShadow, radius: 2, x: 0, y: 2))
        }.animation(.none)
        
        return Group {
            FormItem(name: "所属目标", rightContent: goalMenu)
            ExDivider()
        }
    }
    
    var taskValue: some View {
        let rightContent = HStack(spacing: 0.0) {
            Text(String(taskState.difficulty.rawValue))
                .foregroundColor(taskColor)
            Text(" * \(taskState.timeCost) = ")
            Text(String(taskState.difficulty.rawValue * taskState.timeCost))
                .foregroundColor(Color.rewardGold)
            Image("NutIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 16.0, height: 16.0)
                .padding(.all, 2.0)
                .offset(y: -1)
        }

        return Group {
            FormItem(
                name: "奖励坚果数量",
                rightContent: rightContent
            )
            ExDivider()
        }
    }

    var taskDifficulty: some View {
        VStack(spacing: 0.0) {
            FormItem(name: "难度", rightContent: Text(""))
            DifficultyPicker(difficulty: $taskState.difficulty)
                .padding(.bottom, 20.0)
            ExDivider()
        }
    }
    
    var taskTimeCost: some View {
        Group {
            FormItem(name: "预计耗时", rightContent: Text("\(taskState.timeCost)小时"))
            MySlider(value: $taskState.timeCost, range: 1...10, color: taskColor)
                .padding(.bottom, 20.0)
            ExDivider()
        }
    }

    var taskMyDay: some View {
        Group {
            FormItem(
                name: "在“今日任务”中显示",
                rightContent: Toggle("", isOn:$taskState.starred).toggleStyle(SwitchToggleStyle(tint: taskColor))
            )
            ExDivider()
        }
    }

    var taskRepeat: some View {
        let repeatMenu = Menu {
            ForEach(RepeatFrequency.allCases, id: \.self) {frequency in
                Button(action: {
                    taskState.repeatFrequency = frequency
                }) {
                    Text(RepeatFrequencyText[frequency]!).font(.bodyCustom)
                }
            }
        } label: {
            HStack(spacing: 20.0) {
                Text(RepeatFrequencyText[taskState.repeatFrequency]!)
                    .font(.footnoteCustom)
                    .fontWeight(.bold)
                Image(systemName: "chevron.down")
                    .frame(width: 16.0)
            }
            .padding(10)
            .frame(minWidth: 100)
            .frame(height: 32)
            .background(Color.white.cornerRadius(10).shadow(color: .darkShadow, radius: 2, x: 0, y: 2))
        }.animation(.none)
        
        return Group {
            FormItem(name: "重复频率", rightContent: repeatMenu)
            ExDivider()
        }
    }

    var repeatTimes: some View {
        Group {
            FormItem(name: "重复次数", rightContent: Text("\(taskState.repeatTimes)次"))
            MySlider(value: $taskState.repeatTimes, range: 1...50, color: taskColor)
                .padding(.bottom, 20.0)
            ExDivider()
        }
    }

    var taskDdl: some View {
        let cancelBtn =  Button(action: {
            taskState.hasDdl = false
            taskState.ddl = Date()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16, alignment: .center)
        })
        
        return Button(action: {
            taskState.hasDdl = true
            isShowDatePicker.toggle()
            dismissKeyboard()
        }) {
            FormItem(
                name: "截止日期",
                rightContent: HStack {
                    taskState.hasDdl ? Text("\(dateToString(taskState.ddl)) ") : Text("无")
                    taskState.hasDdl ? cancelBtn : nil
                }
            )
        }
    }

    var cancelDdlBtn: some View {
        Button(action: {
            taskState.hasDdl = false
            taskState.ddl = Date()
            isShowDatePicker.toggle()
        }) {
            Image(systemName: "xmark")
                .resizable()
                .font(Font.subheadCustom.weight(.bold))
                .foregroundColor(.b2)
                .padding(8.0)
                .frame(width: 24.0, height: 24.0)
                .background(Color.g1.cornerRadius(12))
        }
    }
    
//    日期选择
    var datePicker: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Button(action: {
                isShowDatePicker.toggle()
            }) {
                Text("确认")
                    .font(.subheadCustom)
                    .foregroundColor(taskColor)
            }
            DatePicker(
                "日期选择",
                selection: $taskState.ddl,
                displayedComponents: .date
            )
                .accentColor(taskColor)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
        }
        .padding([.top, .leading, .trailing], 20)
        .background(Color.white.cornerRadius(20))
    }
    
//    备注
    var taskDesc: some View {
        TextArea(placeholder: "备注", text: $taskState.desc)
            .padding(.top, 10.0)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0.0) {
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 0.0) {
                        taskTitle
                        showGoal ? taskGoal : nil
                        taskValue
                        taskDifficulty
                        taskTimeCost
                        taskMyDay
                        taskRepeat
                        taskState.repeatFrequency != RepeatFrequency.never ? repeatTimes : nil
                        taskDdl
                        taskDesc
                    }
                    .padding(.horizontal, 25)
                }
            }
            .animation(.easeOut)
            .onTapGesture {
                dismissKeyboard()
            }
            isShowDatePicker ? Color.popupMask : nil
        }
        .popup(isPresented: $isShowDatePicker, type: .floater(verticalPadding: 0), position: .bottom, animation: .easeOut(duration: 0.3), closeOnTap: false, closeOnTapOutside: true, view: { datePicker })
        .onAppear(perform: onAppear)
    }
}

struct TaskFormPreviewWrapper: View {
    @State var taskState = TaskState(nil)

    var body: some View {
        taskState.name = "赚一百万"
        return TaskForm(taskState: $taskState, showGoal: true, onTapClose: emptyFunc, onTapSave: emptyFunc)
    }
}

struct TaskForm_Previews: PreviewProvider {
    static var previews: some View {
        TaskFormPreviewWrapper()
    }
}
