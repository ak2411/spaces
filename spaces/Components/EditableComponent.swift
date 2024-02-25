//
//  EditableComponent.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/24/24.
//

import Foundation
import RealityKit

public struct EditableComponent: Component {
    /// VARS FOR EDITING
    public var dragStart: SIMD3<Float>?
    public var scaleStart: Float?
    public var rotationStart: Float?

    /// The entity this component is currently attached to.
    public var entity: Entity?

    /// The rotation helper entity
}
