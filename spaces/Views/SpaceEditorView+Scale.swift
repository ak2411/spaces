//
//  SpaceEditorView+Scale.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/24/24.
//

import Foundation
import RealityKit
import SwiftUI

extension SpaceEditorView {
    @MainActor
    func handleMagnify(_ value: EntityTargetValue<MagnifyGesture.Value>, ended: Bool = false) {
        if ended {
            scaleStart = nil
            return
        }
        let tappedEntity = value.entity
        if scaleStart == nil {
            scaleStart = tappedEntity.sceneScale
        }
        tappedEntity.sceneScale = max(0.001, min(3, Float(value.magnification) * scaleStart!))
    }
}
