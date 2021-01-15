//
//  FormItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI

struct FormItem<Content: View>: View {
    var icon: Image
    var name: String
    var valueView: Content

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(name)
                    .font(.hiraginoSansGb14)
                Spacer()
                valueView
                    .font(.hiraginoSansGb14)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            Divider()
        }
        .foregroundColor(.myBlack)
    }
}

struct FormItem_Previews: PreviewProvider {
    static var previews: some View {
        FormItem(
            icon: Image(systemName: "gamecontroller"),
            name: "分数",
            valueView: Text("20")
        )
    }
}
