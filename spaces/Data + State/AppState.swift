//
//  AppState.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import ARKit
import FirebaseFirestore
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
    var activeSpace: StickerScene?

    func onSave() throws {
//        TODO: temporary naming. add future feature where names are defined by user or have a default name with counter
        var space = StickerScene(name: UUID().uuidString, description: "Sample description for now")
        root.forEachDescendant(withComponent: EditableComponent.self) { entity, _ in
            space.models.append(StickerPose(translation: entity.scenePosition, real: entity.sceneOrientation.real, imag: entity.sceneOrientation.imag, scale: entity.scale(relativeTo: nil), stickerId: entity.editableComponent!.stickerId))
        }
        do {
            try Firestore.firestore().collection("spaces").document(space.name).setData(from: space)
        } catch {
            throw error
        }
    }

    func addEntityToSpace(sticker: Sticker) async -> Entity? {
        // create the entity
        let url = await fetchFileURL(url: sticker.usdzURL!)
        guard let entity = try? await ModelEntity(contentsOf: url)
        else {
            return nil
        }
        // want a unique id for the specific sticker model
        entity.name = sticker.usdzURL?.absoluteString ?? ""
        entity.generateCollisionShapes(recursive: true)
        // needed for gesture stuff
        entity.components.set(InputTargetComponent())
        // custom editable component
        entity.components.set(EditableComponent(stickerId: sticker.id))

        #if targetEnvironment(simulator)
        entity.position.y = 1.05
        entity.position.z = -1
        #else
        guard let pose = worldInfo.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else {
            entity.position.y = 1.05
            entity.position.z = -1
            return
        }
        let cameraMatrix = pose.originFromAnchorTransform
        let cameraTransform = Transform(matrix: cameraMatrix)
        entity.position = cameraTransform.translation + cameraMatrix.forward * -0.5
        #endif

        root.addChild(entity)
        return entity
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
