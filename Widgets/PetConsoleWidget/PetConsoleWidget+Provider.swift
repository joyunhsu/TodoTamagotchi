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
            let frameCount = 2 // Number of frames in your animation sequence
            let frameInterval: Double = 1.5 // Interval in seconds between frames, now supports decimal values

            // Calculate the number of entries based on the total duration and frame interval
            let totalDuration: Double = 60 // Assuming a total animation cycle duration of 60 seconds
            let numberOfEntries = Int(totalDuration / frameInterval)

            let entries = (0..<numberOfEntries).map {
                let date = startDate.addingTimeInterval(Double($0) * frameInterval)
                let imageName = "frame\(($0 % frameCount) + 1)" // Cycle through frame1, frame2, ..., frameN
                return Entry(date: date, petAssetName: imageName)
            }
            completion(.init(entries: entries, policy: .atEnd))
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
