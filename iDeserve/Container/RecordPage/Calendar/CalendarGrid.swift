//
//  CalendarGrid.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/4.
//

import SwiftUI

struct CalendarGrid: View {
    var dayStat: DayStat
    var size: Int = 40
    var isHighlight: Bool = false
    var isCurrentMonth: Bool = true
    let OpacityBase: Double = 10
    
    var day: Int {
        Calendar.current.dateComponents([Calendar.Component.day], from: dayStat.date).day!
    }

    var body: some View {
        Text(String(day))
            .frame(width: CGFloat(size), height: CGFloat(size))
            .background(
                Color.hospitalGreen
                    .opacity(Double(dayStat.income) / OpacityBase)
            )
            .foregroundColor(isCurrentMonth ? .myBlack : .g40)
            .border(isHighlight ? Color.red : Color.g20, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}

struct CalendarGrid_Previews: PreviewProvider {
    static var previews: some View {
        CalendarGrid(dayStat: DayStat(date: Date(), income: 10, outcome: 10))
    }
}
