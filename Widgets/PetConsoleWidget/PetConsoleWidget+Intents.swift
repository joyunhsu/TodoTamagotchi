//
//  PetConsoleWidget+Intents.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import AppIntents
import WidgetKit
import SwiftUI

struct FeedIntent: AppIntent {

    static var title: LocalizedStringResource = "Feed tamagotchi"

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct PlayIntent: AppIntent {

    static var title: LocalizedStringResource = "Play with tamagotchi"

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

