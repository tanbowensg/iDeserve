//
//  DragRelocateDelegate.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/20.
//

import Foundation
import SwiftUI

struct DragRelocateDelegate: DropDelegate {
    let item: Goal
    var goals: [Goal]
    @Binding var current: Goal?
    @Binding var highlightIndex: Int?

//    总高度要计算目标+padding
    let rowHeight = GOAL_ROW_HEIGHT + GOAL_ROW_PADDING * 2
    
    var itemIndex: Int {
        return Int(goals.firstIndex(of: item)!)
    }

    func updateHighlight(_ y: CGFloat) {
        let remainder = y.truncatingRemainder(dividingBy: rowHeight)
        if CGFloat(remainder) < rowHeight / 2 {
            highlightIndex = itemIndex
        } else {
            highlightIndex = itemIndex + 1
        }
    }
    
    //    根据被拖动的y，计算出新的pos值
    func caculateNewPos(_ y: Int) -> Int {
        let remainder = y % Int(rowHeight)
        var anotherItem: Int
        if CGFloat(remainder) < rowHeight / 2 {
            //            拖拽到上面
            if itemIndex == 0 {
                anotherItem = 0
            } else {
                anotherItem = Int(goals[itemIndex - 1].pos)
            }
        } else {
            //            拖拽到下面
            if itemIndex == goals.count - 1 {
                anotherItem = MAX_POS
            } else {
                anotherItem = Int(goals[itemIndex + 1].pos)
            }
        }
        return Int((anotherItem + Int(item.pos)) / 2)
    }
    
//    func dropEntered(info: DropInfo) {
//        updateHighlight(info.location.y - GOAL_ROW_PADDING)
//    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        updateHighlight(info.location.y)
        return DropProposal(operation: .move)
    }
    
    func dropExited(info: DropInfo) {
    }

    func performDrop(info: DropInfo) -> Bool {
        withAnimation {
            if item.id != current?.id && current != nil {
                let y = info.location.y
                var newPos = caculateNewPos(Int(y))
                
                if (current!.pos == Int16(newPos)) {
                    resetGoalPos()
                    newPos = caculateNewPos(Int(y))
                }
                
                current!.pos = Int16(newPos)
                GlobalStore.shared.coreDataContainer.saveContext()
            }
            
            self.highlightIndex = nil
            self.current = nil
        }
        return true
    }
}
struct DropOutsideDelegate: DropDelegate {
    @Binding var current: Goal?
    @Binding var highlightIndex: Int?
        
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        highlightIndex = nil
        return true
    }
}
