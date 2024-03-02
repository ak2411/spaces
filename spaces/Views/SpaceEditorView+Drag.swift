//
//  SpaceEditorView+Drag.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/24/24.
//

import Foundation
import RealityKit
import SwiftUI

extension SpaceEditorView {
    /// dragStart is global
    @MainActor
    func handleDrag(_ value: EntityTargetValue<DragGesture.Value>, ended: Bool = false) {
        let tappedEntity = value.entity
        if ended {
            tappedEntity.editableComponent?.dragStart = nil
            return
        }
        let translation3D = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)
        let offset = SIMD3<Float>(x: Float(translation3D.x),
                                  y: Float(translation3D.y),
                                  z: Float(translation3D.z))
        if tappedEntity.editableComponent?.dragStart == nil {
            tappedEntity.editableComponent?.dragStart = tappedEntity.scenePosition
        }
        tappedEntity.scenePosition = tappedEntity.editableComponent!.dragStart! + offset
    }
}
