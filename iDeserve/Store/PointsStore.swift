//
//  PointsStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/14.
//

import Foundation

final class PointsStore: ObservableObject {
    static var shared = PointsStore()
    
    private let forKey = "points"

    @Published var points: Int = 0
    
    init () {
        let defaults = UserDefaults.standard
        let _points = defaults.integer(forKey: forKey)
        self.points = _points
        
    }
    
    func saveUserDefaults () {
        let defaults = UserDefaults.standard
        defaults.set(self.points, forKey: forKey)
    }

    func minus (
        _ value: Int
    ) {
        self.points = self.points - value
        self.saveUserDefaults()
    }

    func add (
        _ value: Int
    ) {
        self.points = self.points + value
        self.saveUserDefaults()
    }
}
