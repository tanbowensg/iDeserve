//
//  RewardGrid.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/7.
//

import SwiftUI
import URLImage

struct RewardGrid: View {
    @ObservedObject var reward: Reward
    var onLongPress: ((_ reward: Reward) -> Void)?

    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 0.8)
            .updating($isDetectingLongPress) { currentstate, gestureState,
                    transaction in
                gestureState = currentstate
                transaction.animation = Animation.easeIn(duration: 0.8)
            }
            .onEnded { finished in
                print("长按结束了")
                self.completedLongPress = finished
                self.onLongPress?(reward)
            }
    }

    var cover: some View {
        Image(uiImage: UIImage(data: reward.cover!)!)
            .resizable()
            .aspectRatio(4/3, contentMode: .fit)
            .cornerRadius(16)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(reward.name ?? "未知")
                .font(.subheadline)
                .foregroundColor(.g80)
            reward.cover != nil ? cover : nil
            VStack(alignment: .center){
                Text(String(reward.value))
            }
                .frame(minWidth: 0, maxWidth: .infinity)
        }
            .padding(16)
            .background(self.isDetectingLongPress && !reward.isSoldout ? Color.green : Color.g10)
            .cornerRadius(16)
            .gesture(longPress)
    }
}

//struct RewardGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        RewardGrid(reward: DefaultRewards[2])
//    }
//}
