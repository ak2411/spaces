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

    var editableComponent: EditableComponent? {
        get { components[EditableComponent.self] }
        set { components[EditableComponent.self] = newValue }
    }

    /// Returns an array containing all descendants with a name that includes a specified substring.
    func descendants(containingSubstring substring: String) -> [Entity] {
        var childTransforms = children.filter { child in
            child.name.contains(substring)
        }
        var myTransforms = [Entity]()
        for child in children {
            childTransforms.append(contentsOf: child.descendants(containingSubstring: substring))
        }
        myTransforms.append(contentsOf: childTransforms)
        return myTransforms
    }

    /// Recursive search of children looking for any descendants with a specific component and calling a closure with them.
    func forEachDescendant<T: Component>(withComponent componentClass: T.Type, _ closure: (Entity, T) -> Void) {
        for child in children {
            if let component = child.components[componentClass] {
                closure(child, component)
            }
            child.forEachDescendant(withComponent: componentClass, closure)
        }
    }
}
