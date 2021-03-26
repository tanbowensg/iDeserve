//
//  FormItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI

struct FormItem<Content: View>: View {
    var name: String
    var rightContent: Content
    var onClickHelp: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(name)
                    .font(.subheadCustom)
                    .foregroundColor(.subtitle)
                
                onClickHelp == nil ? nil : Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.subtitle)
                    .onTapGesture {
                        onClickHelp!()
                    }
                
                Spacer()
                rightContent
                    .font(.subheadCustom)
                    .foregroundColor(.body)
            }
            .padding(.vertical, 20)
        }
        .foregroundColor(.myBlack)
    }
}

struct FormItemPreviewWrapper: View {
    @State var isOn = false

    var body: some View {
        VStack(spacing: 0.0) {
            FormItem(
                name: "分数",
                rightContent: Text("Easy")
            )
            FormItem(
                name: "开关",
                rightContent: Toggle("", isOn: $isOn)
            )
        }
    }
}

struct FormItem_Previews: PreviewProvider {
    static var previews: some View {
        FormItemPreviewWrapper()
    }
}
