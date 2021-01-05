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
                default:
                    print(phase)
            }
        }
    }
}
