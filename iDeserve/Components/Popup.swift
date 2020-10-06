//
//  Popup.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/6.
//

import SwiftUI

struct Popup<Content: View>: View {
    var isVisible: Bool
    var content: Content
    var alignment: Alignment = .bottom

    var body: some View {
        if isVisible {
            ZStack(alignment: alignment) {
                Color.g80.opacity(0.1)
                    .edgesIgnoringSafeArea(.vertical)
                content
            }
        }
    }
}

struct Popup_Previews: PreviewProvider {
    static var previews: some View {
        Popup(isVisible: true, content: Text("Hello Popup!"))
    }
}
