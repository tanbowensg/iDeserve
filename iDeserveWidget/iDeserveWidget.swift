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
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), taskStates: [TaskState(name: "placeholder")])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, taskStates: [TaskState(name: "snapshot")])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        do {
            // 从 coredata 获取任务数据
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
            let tasks = try CoreDataContainer.shared.context.fetch(fetchRequest) as! [Task]
            let uncompletedTasks = tasks.filter{ return !$0.done }
            let taskStates = uncompletedTasks.map { TaskState($0) }
            
            let entry = SimpleEntry(
                date: Date(),
                configuration: configuration,
                taskStates: taskStates
            )
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } catch {
            fatalError("小组件中获取任务失败")
        }
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
        switch family {
        case .systemMedium:
            return Array(entry.taskStates.prefix(4))
        case .systemLarge:
            return entry.taskStates
        case .systemSmall:
            return Array(entry.taskStates.prefix(4))
        @unknown default:
            return entry.taskStates
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("今日任务")
                .font(.subheadCustom)
                .fontWeight(.bold)
                .foregroundColor(.b4)
                .padding(.bottom, 4)
            ForEach(tasks) {taskState in
                WidgetTask(name: taskState.name, value: taskState.value)
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct iDeserveWidget_Previews: PreviewProvider {
    static var previews: some View {
        iDeserveWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), taskStates: [TaskState(name: "完成小组件")]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
