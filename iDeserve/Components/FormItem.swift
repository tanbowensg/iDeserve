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
    var onClickHelp: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(name)
                    .font(.subheadCustom)
                
                onClickHelp == nil ? nil : Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .onTapGesture {
                        onClickHelp!()
                    }
                
                Spacer()
                valueView
                    .font(.subheadCustom)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .frame(height: 56.0)
            Divider()
        }
        .foregroundColor(.myBlack)
    }
}

struct FormItemPreviewWrapper: View {
    @State var isOn = false

    var body: some View {
        VStack(spacing: 0.0) {
            FormItem(
                icon: Image(systemName: "gamecontroller"),
                name: "分数",
                valueView: Text("20")
            )
            FormItem(
                icon: Image(systemName: "gamecontroller"),
                name: "开关",
                valueView: Toggle("", isOn: $isOn)
            )
        }
    }
}

struct FormItem_Previews: PreviewProvider {
    static var previews: some View {
        FormItemPreviewWrapper()
    }
}
