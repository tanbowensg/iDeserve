//
//  GlobalStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/9.
//

import Foundation
import SwiftUI
import CoreData

final class GlobalStore: ObservableObject {
    @Published var isShowPayPage = false
    @Published var currentMaskNum = 0
    
    var isShowMask: Bool {
        currentMaskNum > 0
    }

    var moc = CoreDataContainer.shared.context
    static var shared = GlobalStore()
    var coreDataContainer = CoreDataContainer.shared
    var pointsStore = PointsStore.shared
    var goalStore = GoalStore.shared
    var taskStore = TaskStore.shared
    var recordStore = RecordStore.shared
    var rewardStore = RewardStore.shared
    var iapHelper = IAPHelper(productIds: [PRO_IDENTIFIER])
    
    init() {
//        CloudHelper.shared.read()
    }
}
