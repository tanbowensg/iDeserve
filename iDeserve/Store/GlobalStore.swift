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
    var moc = CoreDataContainer.shared.context
    static var shared = GlobalStore()

    var pointsStore = PointsStore.shared
    var goalStore = GoalStore.shared
    var taskStore = TaskStore.shared
    var recordStore = RecordStore.shared
}
