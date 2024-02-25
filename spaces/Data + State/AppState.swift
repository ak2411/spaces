//
//  AppState.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import ARKit
import FirebaseStorage
import Foundation
import RealityKit
import SwiftUI

@MainActor
@Observable
public class AppState {
    var phase: AppPhase = .startingUp
    public var root = Entity()
    var worldInfo = WorldTrackingProvider()
    var session: ARKitSession = .init()
    
//    func save {
//        root.forEachDescendant(withComponent: EditableComponent.self)
//    }

    func addEntityToSpace(sticker: Sticker) {
        var entity: Entity?
        Task {
            // create the entity
            let url = await fetchFileURL(url: sticker.usdzURL!)
            entity = try await ModelEntity(contentsOf: url)
            
            // want a unique id for the specific sticker model
            entity!.name = sticker.usdzURL?.absoluteString ?? ""
            entity!.generateCollisionShapes(recursive: true)
            // needed for gesture stuff
            entity!.components.set(InputTargetComponent())
            // custom editable component
            entity!.components.set(EditableComponent())
            
            #if targetEnvironment(simulator)
            entity!.position.y = 1.05
            entity!.position.z = -1
            #else
            guard let pose = worldInfo.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else {
                entity!.position.y = 1.05
                entity!.position.z = -1
                return
            }
            let cameraMatrix = pose.originFromAnchorTransform
            let cameraTransform = Transform(matrix: cameraMatrix)
            entity!.position = cameraTransform.translation + cameraMatrix.forward * -0.5
            #endif
            
            root.addChild(entity!)
        }
    }
    
    @MainActor
    func fetchFileURL(url: URL) async -> URL {
        do {
            // if the cache url does not have the entity yet, write it to that location
            if !FileManager.default.fileExists(atPath: url.usdzFileCacheURL!.absoluteString) {
                _ = try await Storage.storage().reference(forURL: url.absoluteString)
                    .writeAsync(toFile: url.usdzFileCacheURL!)
            }
            return url.usdzFileCacheURL!
        } catch {
            fatalError("Unable to get usdz file from local cache")
        }
    }
    
    init() {
        root.name = "Root"
        Task.detached(priority: .high) {
            do {
                try await self.session.run([self.worldInfo])
            } catch {
                print("Error running World Tracking Provider: \(error.localizedDescription)")
            }
        }
    }
}
