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
            TextEditor(text: $text)
                .font(.hiraginoSansGb14w3)
            if text == "" {
                Text(placeholder).foregroundColor(.g60)
                    .font(.hiraginoSansGb14w3)
                    .padding(.vertical, 7)
                    .padding(.horizontal,5)
            }
        }
    }
}
