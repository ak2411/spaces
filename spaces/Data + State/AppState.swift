//
//  AppState.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import Foundation

@Observable
@MainActor
public class AppState {
    var phase: AppPhase = .startingUp
    let cameraAnchor = AnchorEntity(.head)
    
    @discardableResult
    public func addEntityToSpace(sticker: Sticker) -> Entity {
        Task {
            guard let url = URL("https://firebasestorage.googleapis.com/v0/b/avp-spaces.appspot.com/o/Earth.usdz?alt=media&token=803cbdb5-c13e-483c-98c7-38d2ff64dcd0")
            // create the entity
            let entity = try await ModelEntity(contentsOf: url)
            // want a unique id for the specific sticker model
            entity.name = sticker?.usdzURL?.absoluteString ?? ""
            entity.generateCollisionShapes(recursive: true)
            // needed for gesture stuff
            entity.components.set(InputTargetComponent())
        }
        root.addChild(entity)
        return entity
    }
    
    init() {
        root.name = "Root"
    }
}
