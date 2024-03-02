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
        let tappedEntity = value.entity
        if ended {
            tappedEntity.editableComponent?.scaleStart = nil
            return
        }
        if tappedEntity.editableComponent?.scaleStart == nil {
            tappedEntity.editableComponent?.scaleStart = tappedEntity.sceneScale
        }
        tappedEntity.sceneScale = max(0.001, min(3, Float(value.magnification) * tappedEntity.editableComponent!.scaleStart!))
    }
}
