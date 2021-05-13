//
//  TabContainer.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/2.
//

import SwiftUI

struct TabContainer<Content: View>: View {
    @EnvironmentObject var gs: GlobalStore
    var content: Content
    var tabInfos: [TabInfo]
    var onTabChange: (_ id: String) -> Void

    @State var isShowMask = false

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
        VStack(spacing: 0.0) {
            content
            ZStack {
                HStack(alignment: .top, spacing: 20.0) {
                    ForEach(tabInfos) {tab in
                        TabIcon(tabInfo: tab)
                            .onTapGesture {
                                onTabChange(tab.id)
                            }
                    }
                }
                    .padding(.horizontal, 38.0)
                isShowMask ? PopupMask() : nil
            }
                .frame(height: 58)
                .background(Color.appBg.ignoresSafeArea())
        }
        .onChange(of: gs.isShowMask, perform: { value in
            print(gs.isShowMask)
            isShowMask = value
        })
        .onAppear {
            print(gs.isShowMask)
            isShowMask = gs.isShowMask
        }
    }
}

struct TabContainer_Previews: PreviewProvider {
    static var previews: some View {
        let infos = [
            TabInfo(id: "1", title: "今日任务", imageName: "sun.max", isActive: false),
            TabInfo(id: "2", title: "今日任务", imageName: "sun.max", isActive: false),
            TabInfo(id: "3", title: "今日任务", imageName: "sun.max", isActive: true),
            TabInfo(id: "4", title: "今日任务", imageName: "sun.max", isActive: false)
        ]
        TabContainer(tabInfos: infos, onTabChange: { print($0) }) {
            Text("hello")
        }
    }
}
