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
    @EnvironmentObject var gs: GlobalStore
    @State var currentTab = TabPages.myDay
    
    var tabs: [TabInfo] {
        return [
            TabInfo(id: TabPages.myDay.rawValue, title: MYDAY_TEXT, imageName: "myDay", isActive: currentTab == .myDay),
            TabInfo(id: TabPages.task.rawValue, title: GOAL_LIST_TEXT, imageName: "goalList", isActive: currentTab == .task),
            TabInfo(id: TabPages.reward.rawValue, title: REWARD_STORE_TEXT, imageName: "rewardStore", isActive: currentTab == .reward),
            TabInfo(id: TabPages.record.rawValue, title: RECORD_LIST_TEXT, imageName: "records", isActive: currentTab == .record)
        ]
    }

//    var currentTabName: String {
//        let tab = tabs.first{ $0.id == currentTab.rawValue }!
//        return tab.title
//    }
    
    var tabContent: some View {
        VStack(spacing: 0.0){
            Group {
                switch currentTab {
                case .myDay:
                    MyDayPage()
                case .task:
                    GoalPage()
                case .reward:
                    RewardPage()
                case .record:
                    RecordPage()
                }
            }
        }
    }
    
    func onTabChange (_ id: String) {
        self.currentTab = TabPages(rawValue: id)!
    }

    var body: some View {
        NavigationView {
//                TabView {
//                    MyDayPage().tabItem { TabIcon(tabInfo: tabs[0]) }
//                    TaskPage().tabItem { TabIcon(tabInfo: tabs[1]) }
//                    RewardPage().tabItem { TabIcon(tabInfo: tabs[2]) }
//                    RecordPage().tabItem { TabIcon(tabInfo: tabs[3]) }
//                }
            ZStack(alignment: .topTrailing) {
                TabContainer(tabInfos: tabs, onTabChange: onTabChange) {
                    tabContent
                }
                NutsAndSettings(points: gs.pointsStore.points)
                    .padding(.top, 10)
                    .padding(.horizontal, 25)
            }
        }
    }
}

struct AppWrapper_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            AppWrapper()
        }
    }
}
