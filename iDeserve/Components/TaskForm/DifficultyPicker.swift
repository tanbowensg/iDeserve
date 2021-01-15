//
//  DifficultyPicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI

struct DifficultyPicker: View {
    @Binding var difficulty: Difficulty
    @Binding var isShow: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PickerBlock(title: "轻松", subtitle: "不费吹灰之力就能完成。不过，奖励也低。", isHighlight: difficulty == Difficulty.easy)
                .onTapGesture {
                    withAnimation {
                        difficulty = Difficulty.easy
                        isShow = false
                    }
                }
            
            PickerBlock(title: "普通", subtitle: "跟平时学习工作差不多的难度，还能接受。", isHighlight: difficulty == Difficulty.medium)
                .onTapGesture {
                    withAnimation {
                        difficulty = Difficulty.medium
                        isShow = false
                    }
                }
            
            PickerBlock(title: "挑战", subtitle: "必须全力以赴才能完成。但奖励也很丰厚。", isHighlight: difficulty == Difficulty.hard)
                .onTapGesture {
                    withAnimation {
                        difficulty = Difficulty.hard
                        isShow = false
                    }
                }
        }
        .background(Color.white)
    }
}

struct DifficultyPicker_Previews_Wrapper: View {
    @State var difficulty = Difficulty.hard
    @State var isShow = false

    var body: some View {
        DifficultyPicker(difficulty: $difficulty, isShow: $isShow)
    }
}

struct DifficultyPicker_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyPicker_Previews_Wrapper()
    }
}
