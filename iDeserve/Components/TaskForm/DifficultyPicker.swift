//
//  DifficultyPicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI

struct DifficultyPicker: View {
    @Binding var difficulty: Difficulty
    
    func button(_ d: Difficulty) -> some View {
        let isCurrent = difficulty == d

        return Button(action: { difficulty = d }) {
            Text(DifficultyText[d]!)
                .font(.footnoteCustom)
                .foregroundColor(isCurrent ? Color.white : Color.body)
                .frame(height: 12)
                .padding(.vertical, 10)
                .frame(width: 100.0, height: 32)
                .background(isCurrent ? Color.hospitalGreen : Color.white)
                .cornerRadius(16)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            HStack {
                ForEach(Difficulty.allCases, id: \.self) { d in
                    button(d)
                    Spacer()
                }
            }
            Text(DifficultyDescText[difficulty]!)
                .foregroundColor(.caption)
                .font(.footnoteCustom)
        }
    }
}

struct DifficultyPicker_Previews_Wrapper: View {
    @State var difficulty = Difficulty.hard
    var body: some View {
        DifficultyPicker(difficulty: $difficulty)
    }
}

struct DifficultyPicker_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyPicker_Previews_Wrapper()
    }
}
