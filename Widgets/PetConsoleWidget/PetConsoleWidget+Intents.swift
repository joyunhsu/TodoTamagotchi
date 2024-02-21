//
//  PetConsoleWidget+Intents.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import AppIntents
import WidgetKit
import SwiftUI

struct IdleIntent: AppIntent {

    static var title: LocalizedStringResource = "Encourage Tamago"

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.setValue("idle", forKey: Shared.activityState)
        return .result()
    }
}

struct HeartIntent: AppIntent {

    static var title: LocalizedStringResource = "Encourage Tamago"

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.setValue("heart", forKey: Shared.activityState)
        return .result()
    }
}

struct SleepIntent: AppIntent {

    static var title: LocalizedStringResource = "Let Tamago sleep"

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.setValue("sleep", forKey: Shared.activityState)
        return .result()
    }
}

