//
//  TabContainer.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/2.
//

import SwiftUI

struct TabContainer<Content: View>: View {
    var content: Content
    var tabInfos: [TabInfo]
    var onTabChange: (_ id: String) -> Void

    init(
        tabInfos: [TabInfo],
        onTabChange: @escaping (_ id: String) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.onTabChange = onTabChange
        self.tabInfos = tabInfos
    }

    var body: some View {
        VStack {
            content
            Spacer()
            HStack(alignment: .center, spacing: 20.0) {
                ForEach(tabInfos) {tab in
                    TabIcon(tabInfo: tab)
                        .onTapGesture {
                            onTabChange(tab.id)
                        }
                }
            }
                .frame(height: 48)
                .padding(.horizontal, 38.0)
        }
    }
}

struct TabContainer_Previews: PreviewProvider {
    static var previews: some View {
        let infos = [
            TabInfo(id: "1", title: "我的一天", systemImage: "sun.max", isActive: false),
            TabInfo(id: "2", title: "我的一天", systemImage: "sun.max", isActive: false),
            TabInfo(id: "3", title: "我的一天", systemImage: "sun.max", isActive: true),
            TabInfo(id: "4", title: "我的一天", systemImage: "sun.max", isActive: false)
        ]
        TabContainer(tabInfos: infos, onTabChange: { print($0) }) {
            Text("hello")
        }
    }
}
