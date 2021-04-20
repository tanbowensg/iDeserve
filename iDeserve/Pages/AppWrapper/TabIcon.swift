//
//  TabIcon.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/2.
//

import SwiftUI

struct TabInfo: Identifiable {
    var id: String
    var title: String
    var systemImage: String
    var isActive: Bool
}

struct TabIcon: View {
    var tabInfo: TabInfo

    var body: some View {
        VStack(spacing: 3.0) {
            Image(systemName: tabInfo.systemImage)
                .frame(width: 24, height: 24)
            Text(tabInfo.title)
                .font(.system(size: 10))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }
            .foregroundColor(tabInfo.isActive ? Color.b2 : Color.g2)
            .frame(maxWidth: .infinity)
    }
}

struct TabIcon_Previews: PreviewProvider {
    static var previews: some View {
        let tabInfo1 = TabInfo(id: "今日任务", title: "sun.max", systemImage: "myDay", isActive: false)
        let tabInfo2 = TabInfo(id: "今日任务", title: "sun.max", systemImage: "myDay", isActive: true)
        Group {
            TabIcon(tabInfo: tabInfo1)
            TabIcon(tabInfo: tabInfo2)
        }
    }
}
