//
//  iDeserveApp.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/9/30.
//

import SwiftUI
import CoreData

@main
struct iDeserveApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    init () {
        initGoal()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.bg
                    .ignoresSafeArea()
                AppWrapper()
                    .environment(\.managedObjectContext, GlobalStore.shared.moc)
                    .environmentObject(GlobalStore.shared)
                    .environmentObject(PointsStore.shared)
            }
            .font(.hiraginoSansGb14)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .active:
                    resetRepeatTaskStatus()
                    resetGoalPos()
                case .background:
//                    这是为了解决直接进奖励商店会崩溃的bug
                    resetRewardPos()
                default:
                    print(phase)
            }
        }
    }
}
