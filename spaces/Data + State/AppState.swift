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
    public var viewRoot = Entity()
    public var editRoot = Entity()
    var worldInfo = WorldTrackingProvider()
    var session: ARKitSession = .init()
    var activeSpace: StickerScene?

    func onSave() throws {
//        TODO: temporary naming. add future feature where names are defined by user or have a default name with counter
        var space = StickerScene(name: UUID().uuidString, description: "Sample description for now")
        editRoot.forEachDescendant(withComponent: EditableComponent.self) { entity, _ in
            space.models.append(StickerPose(translation: entity.scenePosition, real: entity.sceneOrientation.real, imag: entity.sceneOrientation.imag, scale: entity.scale(relativeTo: nil), stickerId: entity.editableComponent!.stickerId))
        }
        do {
            try Firestore.firestore().collection("spaces").document(space.name).setData(from: space)
        } catch {
            throw error
        }
    }

    func updateStickersInSpace() {
        resetRoot()
        for model in activeSpace!.models {
            Task {
                await addSavedStickerAsEntity(model: model)
            }
        }
    }

    func resetRoot() {
        switch phase {
        case .editSpace:
            editRoot.children.removeAll()
        case .viewSpace:
            viewRoot.children.removeAll()
        default:
            return
        }
    }

    func addEntityToRoot(entity: Entity) {
        switch phase {
        case .editSpace:
            editRoot.addChild(entity)
        case .viewSpace:
            viewRoot.addChild(entity)
        default:
            print("Not in a valid phase to add entity.")
            return
        }
    }

    func addSavedStickerAsEntity(model: StickerPose) async {
        do {
            let docRef = Firestore.firestore().collection("stickers").document(model.stickerId)
            let doc = try await docRef.getDocument()
            if doc.exists {
                if let entity = try await getStickerAsEntity(sticker: doc.data(as: Sticker.self)) {
                    entity.scenePosition = model.translation
                    entity.sceneOrientation = simd_quatf(real: model.rotation.real, imag: model.rotation.imag)
                    entity.scale = model.scale
                    addEntityToRoot(entity: entity)
                } else {
                    return
                }
            }
        } catch {
            return
        }
    }

    func getStickerAsEntity(sticker: Sticker) async -> Entity? {
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
        return entity
    }

    func addEntityToSpace(sticker: Sticker) async {
        guard let entity = await getStickerAsEntity(sticker: sticker) else {
            return
        }
        addEntityToRoot(entity: entity)
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
        viewRoot.name = "ViewRoot"
        editRoot.name = "EditRoot"
        Task.detached(priority: .high) {
            do {
                try await self.session.run([self.worldInfo])
            } catch {
                print("Error running World Tracking Provider: \(error.localizedDescription)")
            }
        }
    }
}
