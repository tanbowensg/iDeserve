//
//  ImportancePicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI


struct PickerBlock: View {
    var title: String
    var subtitle: String
    var isHighlight: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 10.0) {
                Text(title)
                Text(subtitle).font(.avenirBlack12).foregroundColor(.g60)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .border(
                isHighlight ? Color.rewardColor : Color.g60,
                width: isHighlight ? 2 : 1
            )
            .background(Color.white)
            .padding(.horizontal, 20)
        }
    }
}

struct ImportancePicker: View {
    @Binding var importance: Importance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PickerBlock(title: "普通", subtitle: "普通的目标。", isHighlight: importance == Importance.normal)
                .onTapGesture {
                    importance = Importance.normal
                }
            
            PickerBlock(title: "重要", subtitle: "必须要完成。有额外奖励。", isHighlight: importance == Importance.important)
            .onTapGesture {
                importance = Importance.important
            }
            
            PickerBlock(title: "史诗", subtitle: "非完成不可，影响重大。有大量额外奖励。", isHighlight: importance == Importance.epic)
            .onTapGesture {
                importance = Importance.epic
            }
        }
        .background(Color.white)
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
