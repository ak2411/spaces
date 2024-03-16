//
//  AppPhase.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import Foundation

public enum AppPhase: String, Codable, Sendable, Equatable {
    case startingUp // loading all assets
    case waitingToStart // in start screen
    case editSpace // in immersive space, to edit
    case viewSpace // in immersive space, just to enjoy

    var isImmersed: Bool {
        switch self {
            case .startingUp, .waitingToStart:
                return false
            case .editSpace, .viewSpace:
                return true
        }
    }
}
