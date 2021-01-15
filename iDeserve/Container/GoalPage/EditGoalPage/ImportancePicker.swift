//
//  ImportancePicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI

struct ImportancePicker: View {
    @Binding var importance: Importance
    @Binding var isShow: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PickerBlock(title: "普通", subtitle: "普通的目标。", isHighlight: importance == Importance.normal)
                .onTapGesture {
                    withAnimation {
                        importance = Importance.normal
                        isShow = false
                    }
                }
            
            PickerBlock(title: "重要", subtitle: "必须要完成。有额外奖励。", isHighlight: importance == Importance.important)
                .onTapGesture {
                    withAnimation {
                        importance = Importance.important
                        isShow = false
                    }
                }
            
            PickerBlock(title: "史诗", subtitle: "非完成不可，影响重大。有大量额外奖励。", isHighlight: importance == Importance.epic)
                .onTapGesture {
                    withAnimation {
                        importance = Importance.epic
                        isShow = false
                    }
                }
        }
        .background(Color.white)
    }
}

struct ImportancePicker_Previews_Wrapper: View {
    @State var importance = Importance.normal
    @State var isShow: Bool = false

    var body: some View {
        ImportancePicker(importance: $importance, isShow: $isShow)
    }
}

struct ImportancePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImportancePicker_Previews_Wrapper()
    }
}
