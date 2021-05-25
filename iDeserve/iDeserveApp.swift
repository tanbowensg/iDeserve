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
    @AppStorage(HAS_LANDED) var hasLanded = false
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(AUTO_BACKUP) var autoBackup = false
    @AppStorage(PRO_IDENTIFIER) var isPro = false
    
    init () {
        initData()
    }
    
    var mainApp: some View {
        ZStack {
            Color.appBg
                .ignoresSafeArea()
            AppWrapper()
                .environment(\.managedObjectContext, GlobalStore.shared.moc)
                .environmentObject(GlobalStore.shared)
                .environmentObject(PointsStore.shared)
        }
        .accentColor(.brandGreen)
        .foregroundColor(.b4)
    }

    var body: some Scene {
        WindowGroup {
            mainApp
//            Group {
//                hasLanded ? mainApp : nil
//                !hasLanded ? LandingPage(): nil
//            }
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .active:
                    resetRepeatTaskStatus()
                    resetGoalPos()
                case .inactive:
                    if isPro && autoBackup && CloudHelper.shared.isCloudEnabled() {
                        backupData()
                    }
                default:
                    print(phase)
            }
        }
    }
}
