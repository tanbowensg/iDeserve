//
//  PointsStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/14.
//

import Foundation

final class PointsStore: ObservableObject {
    static var shared = PointsStore()

    @Published var points: Int = 100

    func minus (
        _ value: Int
    ) {
        self.points = self.points - value
    }

    func add (
        _ value: Int
    ) {
        self.points = self.points + value
    }
}
