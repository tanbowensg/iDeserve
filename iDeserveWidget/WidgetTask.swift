//
//  WidgetTask.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/6/2.
//

import SwiftUI

struct WidgetTask: View {
    var name: String
    var value: Int
    
    var body: some View {
        HStack {
            Text(name)
                .font(.footnoteCustom)
                .foregroundColor(.b4)
            Spacer()
            NutIcon(value: value, hidePlus: true)
                .font(.footnoteCustom)
        }
    }
}

struct WidgetTask_Previews: PreviewProvider {
    static var previews: some View {
        WidgetTask(name: "背 100 个单词", value: 80)
    }
}
