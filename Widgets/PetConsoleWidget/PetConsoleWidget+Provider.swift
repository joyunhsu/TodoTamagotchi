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
            let startDate = currentDate.adding(.second, value: -seconds)
            let entries = (0..<30).map { // 60 seconds total, so 30 intervals of 2 seconds each
                let date = startDate.addingTimeInterval(Double($0 * 2))
                let imageName = "frame\($0 % 2 + 1)" // Cycle between "frame1" and "frame2"
                return Entry(date: date, petAssetName: imageName)
            }
//            let entries = (0 ..< 60).map {
//                let date = startDate.adding(.second, value: $0 * 60 - 1)
//                let imageName = "frame\($0 % 2 + 1)"
//                return Entry(date: date, petAssetName: imageName)
//            }
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
