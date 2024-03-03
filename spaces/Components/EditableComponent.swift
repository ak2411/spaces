//
//  EditableComponent.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/24/24.
//

import Foundation
import RealityKit

public struct EditableComponent: Component {
    public var stickerId: String
    /// VARS FOR EDITING
    public var dragStart: SIMD3<Float>?
    public var scaleStart: Float?
    public var rotationStart: Double?
}
