//
//  FormItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI

struct FormItem<Content: View>: View {
    var name: String
    var valueView: Content
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
                    .onTapGesture {
                        onClickHelp!()
                    }
                
                Spacer()
                valueView
                    .font(.subheadCustom)
                    .foregroundColor(.body)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
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
                name: "分数",
                valueView: Text("Easy")
            )
            FormItem(
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
