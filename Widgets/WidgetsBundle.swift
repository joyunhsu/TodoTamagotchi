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
    
    let profile: Profile = {
        let userDefaults = UserDefaults(suiteName: "group.com.joyunhsu.todoTamagotchi")
        if let progressLevelInt = userDefaults?.integer(forKey: "LifeCycleStringKey") {
            return Profile(activity: .idle(progressLevel: progressLevelInt))
        } else {
            return Profile(activity: .idle(progressLevel: 0))
        }
    }()

    var body: some Widget {
        PetConsoleWidget(profile: profile)
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
