//
//  Entity+Utilities.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/19/24.
//

import Foundation
import RealityKit

public extension Entity {
    var scenePosition: SIMD3<Float> {
        get { position(relativeTo: nil) }
        set { setPosition(newValue, relativeTo: nil) }
    }

    var sceneScale: Float {
        get { scale(relativeTo: nil).x }
        set { setScale(.init(newValue, newValue, newValue), relativeTo: nil) }
    }

    var sceneOrientation: simd_quatf {
        get { orientation(relativeTo: nil) }
        set { setOrientation(newValue, relativeTo: nil) }
    }
}
