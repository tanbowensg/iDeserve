//
//  SettingsPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI
import CoreData
import StoreKit

struct SettingsPage: View {
    @EnvironmentObject var gs: GlobalStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage(PRO_IDENTIFIER) var isPro = false
    @AppStorage(START_TIME_OF_DAY) var startTimeOfDay: Int = 0
    @FetchRequest(fetchRequest: taskRequest) var allTasks: FetchedResults<Task>

    @State var isShowTimePicker = false
    let IntroUrl = "https://thoughts.teambition.com/share/605844ad2aee180046db20bd"
    let ContactUrl = "https://thoughts.teambition.com/share/60a380f043b2b70046b09cd2"

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
        .background(Color.white)
    }
    
    var card: some View {
        ZStack(alignment: .bottomLeading) {
            Image("rewardBg")
                .resizable()
                .cornerRadius(25)
                .padding(.horizontal, 25)
                .frame(width: UIScreen.main.bounds.size.width)
            Image("headerNuts")
                .scaleEffect(x: -1)
                .padding(.horizontal, 25)
                .frame(width: UIScreen.main.bounds.size.width)
            VStack(alignment: .leading) {
                Text("坚果目标 Pro")
                    .font(.titleCustom)
                    .fontWeight(.bold)
                Spacer()
                Text(isPro ? "已购买" : "未购买")
                    .font(.bodyCustom)
                    .fontWeight(.bold)
            }
                .foregroundColor(.b3)
                .padding(.vertical, 25)
                .padding(.horizontal, 50)
        }
            .frame(height: UIScreen.main.bounds.size.width * 0.6)
            .shadow(color: Color.lightShadow, radius: 10, x: 0, y: 2)
            .saturation(isPro ? 1 : 0)
            .onTapGesture {
                gs.isShowPayPage = true
            }
            
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    isShowTimePicker = false
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.b2)
                        .font(Font.headlineCustom.weight(.bold))
                        .padding(25)
                }
                card
                    .padding(.bottom, 25)
                List {
                    Section(header: Text("App 基本信息")) {
                        NavigationLink(destination: WebPage(url: IntroUrl)) {
                            Text("App 上手指南（推荐看）")
                        }
                        Button (action: {
    //                        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/id1550900596?action=write-review")!)
                            SKStoreReviewController.requestReview()
                        }) {
                            Text("好评鼓励")
                        }
                        NavigationLink(destination: WebPage(url: ContactUrl)) {
                            Text("反馈交流")
                        }
                        NavigationLink(destination: BackupPage()) {
                            Text("iCloud 数据备份")
                        }
                        Button(action: {
                            gs.iapHelper.restorePurchases()
                        }) {
                            Text("恢复购买")
                        }
                        Button(action: {
                            isShowTimePicker.toggle()
                        }) {
                            HStack {
                                Text("设定一天的起始时间")
                                Spacer()
                                Text("\(startTimeOfDay):00")
                            }
                        }
                    }
                    
                    Section(header: Text("调试用按钮")) {
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
                }
                .listStyle(GroupedListStyle())
            }
            isShowTimePicker ? PopupMask() : nil
        }
        .navigationBarHidden(true)
        .popup(isPresented: $isShowTimePicker, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: false) {
            timePicker
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
