//
//  iDeserveWidget.swift
//  iDeserveWidget
//
//  Created by 谈博文 on 2021/6/2.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            taskStates: [
                TaskState(name: "锻炼 1 小时"),
                TaskState(name: "写 1 篇作文"),
                TaskState(name: "看书 1 小时"),
                TaskState(name: "写日记")
            ]
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do {
            // 从 coredata 获取任务数据
            let fetchRequest: NSFetchRequest<Task> = NSFetchRequest(entityName: "Task")
            let tasks = try CoreDataContainer.shared.context.fetch(fetchRequest)
            let myDayTasks = filterMyDayTask(tasks)
            let taskStates = myDayTasks.map { TaskState($0) }
            let entry = SimpleEntry(
                date: Date(),
                configuration: configuration,
                taskStates: taskStates
            )
            completion(entry)
        } catch {
            fatalError("小组件中获取任务失败")
        }
        
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for minuteOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!

            do {
                // 从 coredata 获取任务数据
                let fetchRequest: NSFetchRequest<Task> = NSFetchRequest(entityName: "Task")
                let tasks = try CoreDataContainer.shared.context.fetch(fetchRequest)
                let myDayTasks = filterMyDayTask(tasks)
                let taskStates = myDayTasks.map { TaskState($0) }
                let entry = SimpleEntry(
                    date: entryDate,
                    configuration: configuration,
                    taskStates: taskStates
                )
                entries.append(entry)
            } catch {
                fatalError("小组件中获取任务失败")
            }
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let taskStates: [TaskState]
}

struct iDeserveWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var tasks: [TaskState] {
        let completedTasks = entry.taskStates.filter { $0.done }
        var uncompletedTasks = entry.taskStates.filter { return !$0.done }
        uncompletedTasks.append(contentsOf: completedTasks)
        let _tasks = uncompletedTasks

        switch family {
        case .systemMedium:
            return Array(_tasks.prefix(4))
        case .systemLarge:
            return _tasks
        case .systemSmall:
            return Array(_tasks.prefix(4))
        @unknown default:
            return _tasks
        }
    }

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text("今日任务")
                .font(.subheadCustom)
                .fontWeight(.bold)
                .foregroundColor(.b4)
                .padding(.bottom, 4)
            ForEach(tasks) {taskState in
                WidgetTask(name: taskState.name, value: taskState.value, done: taskState.done)
                    .padding(.top, 5)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.appBg)
    }
}

@main
struct iDeserveWidget: Widget {
    let kind: String = "iDeserveWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            iDeserveWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("今日任务")
        .description("呈现今日要做的任务")
    }
}

struct iDeserveWidget_Previews: PreviewProvider {
    static var previews: some View {
        iDeserveWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), taskStates: [TaskState(name: "完成小组件")]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
