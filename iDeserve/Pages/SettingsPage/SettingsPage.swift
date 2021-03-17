//
//  SettingsPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI
import CoreData

struct SettingsPage: View {
    @EnvironmentObject var gs: GlobalStore
    @State var isShowTimePicker = false
    @AppStorage(START_TIME_OF_DAY) var startTimeOfDay: Int = 0
    @FetchRequest(fetchRequest: taskRequest) var allTasks: FetchedResults<Task>

    static var taskRequest: NSFetchRequest<Task> {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = []
        return request
    }

    var timePicker: some View {
        VStack(alignment: .trailing){
            Button(action: {
                isShowTimePicker = false
            }) {
                Text("确认")
            }
            .padding(16.0)
            Picker("一天的开始时间", selection: $startTimeOfDay) {
                ForEach(0...23, id: \.self) {i in
                    Text("\(i):00").tag(i)
                }
                .labelsHidden()
            }
            .onChange (of: startTimeOfDay) { selectedGoalId in
                startTimeOfDay = startTimeOfDay
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                NavigationLink(destination: HelpPage()) {
                    HStack {
                        Text("帮助")
                    }
                }
                HStack {
                    Text("外观")
                }
                Button(action: {
                    gs.pointsStore.add(gs.pointsStore.points * 9)
                }) {
                    Text("现有坚果变十倍")
                }
                Button(action: {
                    gs.pointsStore.add(-gs.pointsStore.points)
                }) {
                    Text("现有坚果清零")
                }
                Button(action: {
                    let defaults = UserDefaults.standard
                    defaults.setValue(true, forKey: UNLOCK_CALENDAR)
                }) {
                    Text("直接解锁松鼠日历")
                }
                Button(action: {
                    isShowTimePicker.toggle()
                }) {
                    HStack {
                        Text("一天的起始时间")
                        Spacer()
                        Text("\(startTimeOfDay):00")
                    }
                }
                Button(action: {
                    allTasks.forEach {task in
                        if task.done
                            && task.repeatFrequency != RepeatFrequency.never.rawValue
                            && task.completeTimes < task.repeatTimes
                        {
                            task.nextRefreshTime = getNextRefreshTime(task)
                        }
                    }
                    gs.coreDataContainer.saveContext()
                }) {
                    HStack {
                        Text("重新计算任务的刷新时间")
                    }
                }
            }
            MyPopup(isVisible: $isShowTimePicker, content: timePicker)
        }
        .navigationTitle("设置")
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
