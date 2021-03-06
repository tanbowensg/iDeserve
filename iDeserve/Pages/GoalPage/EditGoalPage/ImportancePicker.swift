//
//  ImportancePicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI

struct ImportancePicker: View {
    @Binding var importance: Importance
    
    func button(_ i: Importance) -> some View {
        let isCurrent = importance == i

        return Button(action: { importance = i }) {
            Text(ImportanceText[i]!)
                .font(.footnoteCustom)
                .foregroundColor(isCurrent ? Color.white : Color.b3)
                .fontWeight(.bold)
                .frame(height: 12)
                .padding(.vertical, 10)
                .frame(width: 100.0, height: 32)
                .background(isCurrent ? ImportanceColor[i] : Color.white)
                .cornerRadius(16)
                .animation(.none)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            HStack {
                ForEach(Importance.allCases, id: \.self) { i in
                    button(i)
                    Spacer()
                }
            }
            Text(ImportanceDescText[importance]!)
                .foregroundColor(.b1)
                .font(.captionCustom)
        }
    }
}

struct ImportancePicker_Previews_Wrapper: View {
    @State var importance = Importance.normal

    var body: some View {
        ImportancePicker(importance: $importance)
    }
}

struct ImportancePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImportancePicker_Previews_Wrapper()
    }
}
