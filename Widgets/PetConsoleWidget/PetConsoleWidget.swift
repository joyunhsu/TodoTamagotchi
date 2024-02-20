//
//  PetConsoleWidget.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import SwiftUI
import WidgetKit

struct PetConsoleWidget: Widget {

    init() {
        fatalError("Must call init with profile")
    }

    init(profile: Profile) {
        self.profile = profile
    }

    private let kind: String = WidgetType.petConsole.kind
    private var profile: Profile

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) {
            EntryView(entry: $0)
        }
        .configurationDisplayName("Pet Console Widget")
        .description("Enjoy your time with cute tamagotchi.")
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
