//
//  PetConsoleWidget+Entry.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import WidgetKit
import SwiftUI

extension PetConsoleWidget {
    struct Entry: TimelineEntry {
        var date: Date = .now
        var petAssetName: String
    }
}

extension PetConsoleWidget.Entry {
    static var placeholder: Self {
        .init(petAssetName: "egg_3-0")
    }
}
