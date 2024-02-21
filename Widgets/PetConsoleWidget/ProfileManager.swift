//
//  ProfileManager.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import Foundation

struct Profile {

    let lifecycle: Lifecycle
    let activity: Activity

    enum Activity {
        case idle
        case heart
        case sleep

        var assetNamePrefix: String? {
            switch self {
            case .idle:
                return nil
            case .heart:
                return "egg_heart"
            case .sleep:
                return "egg_sleep"
            }
        }
    }

    enum Lifecycle: String {
        case egg
        case crackedEgg
        case chick
        case fledgling
        case grownChicken
        case finishLine

        var assetNamePrefix: String {
            switch self {
            case .egg:
                return "egg_0"
            case .crackedEgg:
                return "egg_1"
            case .chick:
                return "egg_2"
            case .fledgling:
                return "egg_3"
            case .grownChicken:
                return "egg_4"
            case .finishLine:
                return "egg_5"
            }
        }
    }
}

extension Profile.Lifecycle {
    func imageName(forFrame frame: Int) -> String {
        // Ensure the frame number is within the valid range of 0 to 3
        guard frame >= 0 && frame < 4 else {
            fatalError("Invalid frame number. Frame must be between 0 and 3.")
        }
        return "\(self.assetNamePrefix)-\(frame)"
    }
}

extension Profile.Activity {
    func imageName(forFrame frame: Int) -> String? {
        // Ensure the frame number is within the valid range of 0 to 3
        guard frame >= 0 && frame < 4 else {
            fatalError("Invalid frame number. Frame must be between 0 and 3.")
        }
        if let prefix = self.assetNamePrefix {
            return "\(prefix)-\(frame)"
        } else {
            return nil
        }
    }
}
