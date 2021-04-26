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
    var imageName: String
    var isActive: Bool
}

struct TabIcon: View {
    var tabInfo: TabInfo

    var body: some View {
        VStack(spacing: 3.0) {
            Image(tabInfo.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .scaleEffect(tabInfo.isActive ? 2 : 1, anchor: .bottom)
                .shadow(color: .g2, radius: tabInfo.isActive ? 3 : 0, x: 0, y: 0)
            Text(tabInfo.title)
                .font(.captionCustom)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(tabInfo.isActive ? Color.init(hex: "eea849") : .b1)
        }
            .saturation(tabInfo.isActive ? 1 : 0)
            .frame(maxWidth: .infinity)
            .animation(.easeIn(duration: 0.15), value: tabInfo.isActive)
    }
}

struct TabIcon_Previews: PreviewProvider {
    static var previews: some View {
        let tabInfo1 = TabInfo(id: "今日任务", title: "sun.max", imageName: "myDay", isActive: false)
        let tabInfo2 = TabInfo(id: "今日任务", title: "sun.max", imageName: "myDay", isActive: true)
        Group {
            TabIcon(tabInfo: tabInfo1)
            TabIcon(tabInfo: tabInfo2)
        }
    }
}
