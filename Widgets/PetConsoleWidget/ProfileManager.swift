//
//  ProfileManager.swift
//  WidgetsExtension
//
//  Created by Jo Hsu on 2024/2/20.
//

import Foundation

enum Shared {
    static let activityState = "activityState"
    static let progressLevelIntKey = "ProgressLevelIntKey"
}

struct Profile {
    let activity: Activity

    enum Activity {
        case idle(progressLevel: Int)
        case heart
        case sleep

        var assetNamePrefix: String {
            switch self {
            case let .idle(progressLevel):
                switch progressLevel {
                case 1:
                    return "egg_1"
                case 2:
                    return "egg_2"
                case 3:
                    return "egg_3"
                case 4:
                    return "egg_4"
                case 5:
                    return "egg_5"
                default:
                    return "egg_0"
                }
            case .heart:
                return "egg_heart"
            case .sleep:
                return "egg_sleep"
            }
        }
    }

//    enum Lifecycle: String {
//        case egg
//        case crackedEgg
//        case chick
//        case fledgling
//        case grownChicken
//        case finishLine
//    }
}

extension Profile.Activity {
    func imageName(forFrame frame: Int) -> String {
        // Ensure the frame number is within the valid range of 0 to 3
        guard frame >= 0 && frame < 4 else {
            fatalError("Invalid frame number. Frame must be between 0 and 3.")
        }
        return "\(self.assetNamePrefix)-\(frame)"
    }
}
