//
//  SettingsPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct SettingsPage: View {
    @EnvironmentObject var gs: GlobalStore

    var body: some View {
//        VStack {
//            Text("设置")
//                .font(.hiraginoSansGb16)
//            Divider()
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
            }
//        }
        .navigationTitle("设置")
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
