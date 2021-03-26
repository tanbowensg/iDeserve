//
//  TextArea.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/11.
//

import SwiftUI
import UIKit

struct TextArea: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.footnote)
                .lineSpacing(7)
                .zIndex(1)
            Text(text)
                .opacity(0)
                .font(.footnote)
                .lineSpacing(7)
                .padding(.vertical, 8)
                .padding(.horizontal,5)
                .fixedSize(horizontal: false, vertical: true)
                .zIndex(-1)
                .disabled(true)
            if text == "" {
                Text(placeholder)
                    .font(.footnote)
                    .padding(.vertical, 8)
                    .padding(.horizontal,5)
            }
        }
        .padding(20)
        .background(Color.descBg)
        .foregroundColor(.rewardColor)
        .frame(minHeight: 109)
        .cornerRadius(20)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}

struct TextAreaPreviewWrapper: View {
    @State var text = "sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf"

    var body: some View {
        return TextArea(placeholder: "备注", text: $text)
    }
}

struct TextArea_Previews: PreviewProvider {
    static var previews: some View {
        TextAreaPreviewWrapper()
    }
}
