//
//  RewardGrid.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/7.
//

import SwiftUI
import CoreData

struct RewardGrid: View {
    @ObservedObject var reward: Reward
//    var onLongPress: ((_ reward: Reward) -> Void)?

//    @GestureState var isDetectingLongPress = false
//    @State var completedLongPress = false

//    var longPress: some Gesture {
//        LongPressGesture(minimumDuration: 0.8)
//            .updating($isDetectingLongPress) { currentstate, gestureState,
//                    transaction in
//                gestureState = currentstate
//                transaction.animation = Animation.easeIn(duration: 0.8)
//            }
//            .onEnded { finished in
//                print("长按结束了")
//                self.completedLongPress = finished
//                self.onLongPress?(reward)
//            }
//    }

    var cover: some View {
        Image(uiImage: UIImage(data: reward.cover!)!)
            .resizable()
            .aspectRatio(4/3, contentMode: .fit)
            .cornerRadius(16)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(reward.name ?? "未知")
                .font(.hiraginoSansGb14)
                .fontWeight(.black)
                .foregroundColor(.white)
            HStack(alignment: .center){
                Text(String(reward.value))
                    .font(.avenirBlack12)
                    .fontWeight(.black)
                    .foregroundColor(.white)
            }
                .frame(height: 25.0)
        }
            .padding(14)
        .frame(height: 100.0)
        .background(Color.rewardColor)
//        .background(self.isDetectingLongPress && !reward.isSoldout ? Color.green : Color.g10)
            .cornerRadius(10)
//            .gesture(longPress)
            .id(reward.id)
    }
}


struct RewardGrid_Previews: PreviewProvider {
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    static var previews: some View {
        let context = CoreDataContainer.shared.context
        let rewards = genMockRewards(context)

        return ScrollView {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    alignment: .center,
                    spacing: 16
                ) {
                    ForEach(rewards, id: \.id) { (reward: Reward) in
                        RewardGrid(reward: reward)
                    }
                }
                .padding(16)
            }
        }
    }
}
