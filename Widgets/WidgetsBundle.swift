//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by Jo Hsu on 2024/2/20.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        PetConsoleWidget()
    }
}

enum WidgetType: String {
    case petConsole // medium game console
}

// MARK: - Helpers

extension WidgetType {
    var kind: String {
        rawValue + "Widget"
    }
}
