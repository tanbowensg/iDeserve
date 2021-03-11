//
//  TextArea.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/11.
//

import SwiftUI

struct TextArea: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text).padding(0)
            if text == "" {
                Text(placeholder).foregroundColor(.g60)
                    .padding(.vertical, 7)
                    .padding(.horizontal,5)
            }
        }
        .frame(width: 200, height: 300, alignment: .center)
    }
}
