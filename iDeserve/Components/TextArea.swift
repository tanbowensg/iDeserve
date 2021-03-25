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
                .font(.footnoteCustom)
            if text == "" {
                Text(placeholder)
                    .font(.bodyCustom)
                    .padding(.vertical, 7)
                    .padding(.horizontal,5)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
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
    @State var text = ""

    var body: some View {
        return TextArea(placeholder: "备注", text: $text)
    }
}

struct TextArea_Previews: PreviewProvider {
    static var previews: some View {
        TextAreaPreviewWrapper()
    }
}
