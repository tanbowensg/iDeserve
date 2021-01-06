//
//  RewardPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct RewardPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore
    @FetchRequest(fetchRequest: rewardRequest) var rewards: FetchedResults<Reward>

    @State var isEditMode = false
    @State var isTapped = false
    @State var dragging: Reward? = nil

    static var rewardRequest: NSFetchRequest<Reward> {
        let request: NSFetchRequest<Reward> = Reward.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Reward.pos, ascending: true)
        ]
        return request
   }

    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var rewardsArray: [Reward] {
        rewards.map{ return $0 }
    }
    
    func genRewardGrid(reward: Reward) -> some View {
        print(isEditMode)
        return VStack {
            NavigationLink(destination:  EditRewardPage(initReward: reward), isActive: $isTapped) {
                EmptyView()
            }
            RewardGrid(reward: reward, isEditMode: isEditMode)
                .onTapGesture {
                    if isEditMode == true {
                        setIsEditMode(false)
                    } else {
                        isTapped.toggle()
                    }
                }
                .onDrag() {
                    setIsEditMode(true)
                    self.dragging = reward
                    return NSItemProvider(object: reward.id!.uuidString as NSString)
                }
                .onDrop(of: [UTType.text], delegate: DragRewardRelocateDelegate(item: reward, listData: rewardsArray, current: $dragging))
        }
    }
    
    func setIsEditMode (_ value: Bool) {
        if value == true {
            withAnimation(Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
                isEditMode = true
            }
        } else {
            withAnimation(.default) {
                isEditMode = false
            }
        }
    }

    var body: some View {
        return
            VStack(spacing: 0.0) {
                AppHeader(points: gs.pointsStore.points, title: "奖励商店")
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: 16
                        ) {
                            ForEach(rewards, id: \.id) { (reward: Reward) in
                                genRewardGrid(reward: reward)
                            }
                        }
                        .padding(16)
                        .animation(.spring(), value: rewardsArray)
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(destination: EditRewardPage(initReward: nil)) {
                                CreateButton()
                            }
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.bottom, 16)
                }
            }
                .navigationBarHidden(true)
                .onTapGesture {
                    setIsEditMode(false)
                }
    }
}

struct DragRewardRelocateDelegate: DropDelegate {
    let item: Reward
    var listData: [Reward]
    @Binding var current: Reward?
    
    //    根据被拖动的y，计算出新的pos值
    func caculateNewPos() -> Int {
        let fromIndex = listData.firstIndex(of: current!)!
        let toIndex = listData.firstIndex(of: item)!
        var nextItemPos: Int

        if fromIndex < toIndex {
            if toIndex == listData.count - 1 {
                nextItemPos = MAX_POS
            } else {
                nextItemPos = Int(listData[toIndex + 1].pos)
            }
        } else {
            if toIndex == 0 {
                nextItemPos = 0
            } else {
                nextItemPos = Int(listData[toIndex - 1].pos)
            }
        }

        return Int((nextItemPos + Int(item.pos)) / 2)
    }

    func dropEntered(info: DropInfo) {
        if item != current {
            var newPos = caculateNewPos()
            if (current!.pos == Int16(newPos)) {
                resetRewardPos()
                newPos = caculateNewPos()
            }
            print(newPos)
            current!.pos = Int16(newPos)
            GlobalStore.shared.coreDataContainer.saveContext()
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}
