//
//  Nav.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
//import CoreData

struct Tab: View {
    @EnvironmentObject var globalStore: GlobalStore
    @Environment(\.managedObjectContext) var managedObjectContext

    func TabIcon (text: String, icon: String) -> some View {
        VStack() {
            Image(systemName: icon)
                .frame(width: 32, height: 32)
            Text(text)
                .font(.system(size: 12))
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(String(globalStore.pointsStore.points))
            }
            TabView {
                TaskPage().tabItem { TabIcon(text: "任务", icon: "list.dash") }
                RewardPage().tabItem { TabIcon(text: "奖励", icon: "dollarsign.circle") }
                RecordPage().tabItem { TabIcon(text: "历史记录", icon: "clock") }
                TaskPage().tabItem { TabIcon(text: "任务", icon: "list.dash") }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            Tab()
        }
    }
}
