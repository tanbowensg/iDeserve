//
//  GoalItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct ProgressBar: View {
    var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: 4)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: 4)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
            }
            .cornerRadius(2)
            .padding(0)
        }
        .frame(height: 4.0)
    }
}

struct GoalItem: View {
    var name: String
    var taskNum: Int
    var value: Int
    var progress: Float

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "gamecontroller")
                .resizable()
                .padding(10)
                .background(Color.tagBg)
                .frame(width: 60.0, height: 60.0)
                .cornerRadius(15)
                .foregroundColor(Color.tagColor)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.hiraginoSansGb16)
                    .padding(.bottom, 2.0)
                Text("\(taskNum) 个任务")
                    .font(.hiraginoSansGb12)
                    .foregroundColor(.g60)
                    .padding(.bottom, 4.0)
                ProgressBar(value: progress)
            }
            Spacer()
            NutIcon(value: 119)
        }
        .padding(.horizontal, 20.0)
        .frame(height: 70.0)
        .frame(maxWidth: .infinity)
        .foregroundColor(.g80)
    }
}

struct GoalItem_Previews: PreviewProvider {
    static var previews: some View {
        GoalItem(name: "通关赛博朋克2077", taskNum: 3, value: 188, progress: 0.32)
    }
}
