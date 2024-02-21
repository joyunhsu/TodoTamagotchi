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
        if let lifeCycleString = userDefaults?.string(forKey: "LifeCycleStringKey"),
           let lifeCycle = Profile.Lifecycle(rawValue: lifeCycleString) {
            return Profile(activity: .idle(lifecycle: lifeCycle))
        } else {
            return Profile(activity: .idle(lifecycle: .egg))
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
