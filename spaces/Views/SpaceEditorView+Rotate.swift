//
//  SpaceEditorView+Rotate.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/24/24.
//

import Foundation
import RealityKit
import simd
import SwiftUI

extension SpaceEditorView {
    @MainActor
    func handleRotation(_ value: EntityTargetValue<RotateGesture.Value>, ended: Bool = false) {
        let targetedEntity = value.entity
        if ended {
            targetedEntity.editableComponent?.rotationStart = nil
            return
        }
        var radians = -value.gestureValue.rotation.radians
        // Increase rotation speed.
        #if targetEnvironment(simulator)
            radians = radians * 3
        #else
            radians = radians * 8
        #endif
        if targetedEntity.editableComponent?.rotationStart == nil {
            targetedEntity.editableComponent?.rotationStart = Double(targetedEntity.sceneOrientation.angle)
        }

        let startAngleDegrees = Angle(radians: targetedEntity.editableComponent!.rotationStart!).degrees
        let angleDegrees = Angle(radians: radians).degrees + startAngleDegrees
        let angleRadians = Angle(degrees: angleDegrees).radians

        targetedEntity.sceneOrientation = simd_quatf(angle: Float(angleRadians), axis: SIMD3<Float>.up).normalized
    }
}
