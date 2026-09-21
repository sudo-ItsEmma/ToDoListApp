//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created on 20/09/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct ToDoListAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TodoItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            #if DEBUG
            SampleData.insertIfEmpty(in: container.mainContext)
            #endif
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        UNUserNotificationCenter.current().delegate = ReminderNotificationDelegate.shared
    }

    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
