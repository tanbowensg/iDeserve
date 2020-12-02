//
//  Nav.swift
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

struct Tab: View {
    @EnvironmentObject var pointsStore: PointsStore
    
    @State var currentTab = TabPages.myDay
    
    var tabs: [TabInfo] {
        return [
            TabInfo(id: TabPages.myDay.rawValue, title: "我的一天", systemImage: "sun.max", isActive: currentTab == .myDay),
            TabInfo(id: TabPages.task.rawValue, title: "目标任务", systemImage: "list.dash", isActive: currentTab == .task),
            TabInfo(id: TabPages.reward.rawValue, title: "奖励商店", systemImage: "gift.fill", isActive: currentTab == .reward),
            TabInfo(id: TabPages.record.rawValue, title: "历史记录", systemImage: "clock", isActive: currentTab == .record)
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
            
            TabContainer(tabInfos: tabs, onTabChange: onTabChange) {
                tabContent
            }
        }
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            Tab()
                .environmentObject(PointsStore.shared)
        }
    }
}
