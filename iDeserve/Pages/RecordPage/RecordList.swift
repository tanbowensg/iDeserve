//
//  RecordList.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/11.
//

import SwiftUI

struct RecordList: View {
    @EnvironmentObject var gs: GlobalStore
    var records: [Record]

    @State private var deletingRecord: Record? = nil
    @State private var isShowAlert = false

    var subtotal: some View {
        let sum = records.reduce(0) { (result, record) -> Int in
            switch RecordKind(rawValue: Int(record.kind)) {
            case .reward:
                return result - Int(record.value)
            case .task:
                return result + Int(record.value)
            case .goal:
                return result + Int(record.value)
            default:
                return result
            }
        }
        return VStack(spacing: 0.0) {
            Divider()
            HStack(alignment: .center) {
                Text("总计")
                    .font(.subheadCustom)
                    .fontWeight(.bold)
                    .foregroundColor(.b3)
                Spacer()
                NutIcon(value: sum)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
        }
        .background(Color.transparent)
    }
    
    var deleteAlert: Alert {
        Alert(
            title: Text("删除记录"),
            message: Text("删除记录以后，坚果数量可以恢复，但是目标、任务和奖励的状态不会改变。确定要删除这条记录吗？"),
            primaryButton: Alert.Button.default(Text("删除")) {
                gs.recordStore.deleteRecord(deletingRecord!)
                deletingRecord = nil
            },
            secondaryButton: Alert.Button.cancel(Text("取消"))
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            CustomScrollView(showsIndicators: false) {
                ForEach (records) { record in
                    SwipeWrapper(
                        content: RecordItem(record: record),
                        height: 38,
                        onRightSwipe: {
                            isShowAlert.toggle()
                            deletingRecord = record
                        }
                    )
                    .alert(
                        isPresented: $isShowAlert,
                        content: { deleteAlert }
                    )
                }
            }
            records.count > 0 ? subtotal : nil
        }
        .font(.subheadCustom)
    }
}

struct RecordItem: View {
    var record: Record
    
    var icon: some View {
        let kind = RecordKind(rawValue: Int(record.kind))
        var imageName: String
        
        switch kind {
            case .goal:
                imageName = "goalList"
            case .task:
                imageName = "check"
            case .reward:
                imageName = "rewardStore"
            default:
                imageName = "check"
        }
        
        return Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20, alignment: .center)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10.0) {
            icon
            Text(record.name ?? "").font(.subheadCustom)
            Spacer()
            NutIcon(value: Int(record.kind == RecordKind.reward.rawValue ? -record.value : record.value))
        }
        .font(.subheadCustom)
        .frame(height: 28)
        .padding(.vertical, 5)
        .padding(.horizontal, 25)
        .background(Color.transparent)
    }
}
