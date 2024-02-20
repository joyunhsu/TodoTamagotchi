//
//  PetConsoleWidget.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import SwiftUI
import WidgetKit

struct PetConsoleWidget: Widget {
    private let kind: String = WidgetType.petConsole.kind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) {
            EntryView(entry: $0)
        }
        .configurationDisplayName("Pet Console Widget")
        .description("Interact with elements of the Widget.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    PetConsoleWidget()
} timeline: {
    PetConsoleWidget.Entry.placeholder
}
