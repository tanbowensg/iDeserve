//
//  AppWrapper.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
//import CoreData

enum TabPages: String {
    case task = "task"
    case reward = "reward"
    case myDay = "myDay"
    case record = "record"
}

struct AppWrapper: View {
    @EnvironmentObject var pointsStore: PointsStore
    
    @State var currentTab = TabPages.myDay
    
    var tabs: [TabInfo] {
        return [
            TabInfo(id: TabPages.myDay.rawValue, title: MYDAY_TEXT, systemImage: "sun.max", isActive: currentTab == .myDay),
            TabInfo(id: TabPages.task.rawValue, title: GOAL_LIST_TEXT, systemImage: "list.dash", isActive: currentTab == .task),
            TabInfo(id: TabPages.reward.rawValue, title: REWARD_STORE_TEXT, systemImage: "gift.fill", isActive: currentTab == .reward),
            TabInfo(id: TabPages.record.rawValue, title: RECORD_LIST_TEXT, systemImage: "clock", isActive: currentTab == .record)
        ]
    }
    
    var tabContent: some View {
        Group {
            switch currentTab {
            case .myDay:
                MyDayPage()
            case .task:
                TaskPage()
            case .reward:
                RewardPage()
            case .record:
                RecordPage()
            }
        }
    }
    
    func onTabChange (_ id: String) {
        self.currentTab = TabPages(rawValue: id)!
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(String(pointsStore.points))
            }
            NavigationView{
//                TabView {
//                    MyDayPage().tabItem { TabIcon(tabInfo: tabs[0]) }
//                    TaskPage().tabItem { TabIcon(tabInfo: tabs[1]) }
//                    RewardPage().tabItem { TabIcon(tabInfo: tabs[2]) }
//                    RecordPage().tabItem { TabIcon(tabInfo: tabs[3]) }
//                }
                TabContainer(tabInfos: tabs, onTabChange: onTabChange) {
                    tabContent
                }
            }
        }
    }
}

struct AppWrapper_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            AppWrapper()
                .environmentObject(PointsStore.shared)
        }
    }
}
