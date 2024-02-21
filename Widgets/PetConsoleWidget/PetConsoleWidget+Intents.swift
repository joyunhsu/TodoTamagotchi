//
//  PetConsoleWidget+Intents.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import AppIntents
import WidgetKit
import SwiftUI

struct HeartIntent: AppIntent {

    static var title: LocalizedStringResource = "Encourage Tamago"

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct SleepIntent: AppIntent {

    static var title: LocalizedStringResource = "Let Tamago sleep"

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

