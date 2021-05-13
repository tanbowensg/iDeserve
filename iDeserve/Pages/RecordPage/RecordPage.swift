//
//  RecordPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/19.
//

import SwiftUI
import CoreData

struct RecordPage: View {
    @EnvironmentObject var gs: GlobalStore
    @FetchRequest(fetchRequest: recordRequest) var records: FetchedResults<Record>
    
    @State var chosenDate: Date? = nil
    @State var currentMonth: Int = Calendar.current.dateComponents([.month], from: Date()).month!
    @State var currentYear: Int = Calendar.current.dateComponents([.year], from: Date()).year!

    let safeAreaHeight: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)!

    static var recordRequest: NSFetchRequest<Record> {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.sortDescriptors = []
        return request
    }

    var dayStats: [DayStat] {
        let startDay = startDateOfMonth(year: currentYear, month: currentMonth)
        let lastDay = endDateOfMonth(year: currentYear, month: currentMonth)
        
        return reduceRecords(
            records: records.map{return $0},
            from: startDay,
            to: lastDay
        )
    }
    
    var prevMonthDayStats: [DayStat] {
        let (prevYear, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
        let startDay = startDateOfMonth(year: prevYear, month: prevMonth)
        let lastDay = endDateOfMonth(year: prevYear, month: prevMonth)
        
        return reduceRecords(
            records: records.map{return $0},
            from: startDay,
            to: lastDay
        )
    }
    
    var nextMonthDayStats: [DayStat] {
        let (nextYear, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
        let startDay = startDateOfMonth(year: nextYear, month: nextMonth)
        let lastDay = endDateOfMonth(year: nextYear, month: nextMonth)
        
        return reduceRecords(
            records: records.map{return $0},
            from: startDay,
            to: lastDay
        )
    }

    var chosenDateRecords: [Record] {
        if let _chosenDate = chosenDate {
            return records.filter { Calendar.current.isDate($0.date!, inSameDayAs: _chosenDate) }
        }

        return []
    }
    
    var monthTitle: some View {
        HStack(spacing: 20.0) {
            Text("\(String(currentYear))年\(currentMonth)月")
                .font(.footnoteCustom)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                let (prevYear, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
                onMonthChange(prevYear, prevMonth)
            }) {
                Image(systemName: "chevron.left")
                    .font(Font.captionCustom.weight(.bold))
                    .padding(4)
            }
            Button(action: {
                let (nextYear, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
                onMonthChange(nextYear, nextMonth)
            }) {
                Image(systemName: "chevron.right")
                    .font(Font.captionCustom.weight(.bold))
                    .padding(4)
            }
        }
        .foregroundColor(.b3)
    }
    
    func recordsView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                monthTitle
                CalendarSwiper(
                    dayStats: dayStats,
                    prevDayStats: prevMonthDayStats,
                    nextDayStats: nextMonthDayStats,
                    currentYear: currentYear,
                    currentMonth: currentMonth,
                    onTapDate: { chosenDate = $0 },
                    onMonthChange: onMonthChange
                )
            }
            .frame(width: CalendarWidth)
            .padding(25)
            .background(Color.white.cornerRadius(25).shadow(color: .lightShadow, radius: 20, x: 0, y: 0))
            .padding(.bottom, 25)
    
            ExDivider()
            RecordList(records: chosenDateRecords)
                .animation(.none)
        }
        .padding(.horizontal, 25)
    }

    var body: some View {
        ZStack(alignment: .top) {
            NutsAndSettings()
                .padding(.top, 10)
                .padding(.horizontal, 25)
                .frame(width: UIScreen.main.bounds.size.width)
                .zIndex(100)
            RecordPageHeader()
            Image("bear")
                .resizable()
                .scaledToFit()
                .frame(width: 293.0, height: 380.0)
                .padding(.top, 30)
                .padding(.trailing, 150)
                .rotationEffect(.init(degrees: 30))
            recordsView()
                .padding(.top, HEADER_HEIGHT - safeAreaHeight)
                .animation(.easeInOut, value: currentMonth)
                .navigationBarHidden(true)
        }
        .frame(width: UIScreen.main.bounds.size.width)
    }
    
    func onMonthChange(_ nextYear: Int, _ nextMonth: Int) -> Void {
        currentYear = nextYear
        currentMonth = nextMonth
        chosenDate = nil
    }
}

struct RecordPage_Previews: PreviewProvider {
    static var previews: some View {
        RecordPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
