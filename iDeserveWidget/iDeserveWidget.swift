//
//  iDeserveWidget.swift
//  iDeserveWidget
//
//  Created by 谈博文 on 2020/11/30.
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
            taskStates: [TaskState(name: "hahha")]
        )
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            configuration: configuration,
            taskStates: [TaskState(name: "hahha")]
        )
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
    
    var body: some View {
        VStack {
            ForEach(entry.taskStates) {taskState in
                TaskItem(task: taskState, onCompleteTask: {}, onRemoveTask: {})
            }
        }
    }
}

//struct PlaceholderView: View {
//    var body: some View {
//        TaskItem(task: entry.task, onCompleteTask: {}, onRemoveTask: {})
//
//    }
//}

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
        iDeserveWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            taskStates: [TaskState(name: "hahha")]
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
