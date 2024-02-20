//
//  PetConsoleWidget+Provider.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import WidgetKit

extension PetConsoleWidget {

    struct Provider: TimelineProvider {

        func placeholder(in context: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            completion(.placeholder)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            let currentDate = Date()
            let seconds = Calendar.current.component(.second, from: currentDate)
            let startDate = currentDate.addingTimeInterval(-Double(seconds))

            // Configurable variables
            let frameCount = 4 // Number of frames in your animation sequence
            let frameInterval: Double = 1 // Interval in seconds between frames, now supports decimal values

            // Calculate the number of entries based on the total duration and frame interval
            let totalDuration: Double = 60 // Assuming a total animation cycle duration of 60 seconds
            let numberOfEntries = Int(totalDuration / frameInterval)

            let entries = (0..<numberOfEntries).map {
                let date = startDate.addingTimeInterval(Double($0) * frameInterval)
                let frameIndex = $0 % frameCount // Cycle through frame1, frame2, ..., frameN
                let imageName = currentProfile().lifecycle.imageName(forFrame: frameIndex)
                return Entry(date: date, petAssetName: imageName)
            }
            completion(.init(entries: entries, policy: .atEnd))
        }

        private func currentProfile() -> Profile {
            let userDefaults = UserDefaults(suiteName: "group.com.joyunhsu.todoTamagotchi")
            if let lifeCycleString = userDefaults?.string(forKey: "LifeCycleStringKey"),
               let lifeCycle = Profile.Lifecycle(rawValue: lifeCycleString) {
                return Profile(lifecycle: lifeCycle)
            } else {
                return Profile(lifecycle: .egg)
            }
        }
    }
}

extension Date {
    func adding(
        _ component: Calendar.Component,
        value: Int,
        in calendar: Calendar = .current
    ) -> Self {
        calendar.date(byAdding: component, value: value, to: self)!
    }
}
