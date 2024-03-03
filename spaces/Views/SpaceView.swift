//
//  SpaceView.swift
//  spaces
//
//  Created by Angelica Kosasih on 3/2/24.
//

import FirebaseFirestore
import Foundation
import RealityKit
import SwiftUI

struct SpaceView: View {
    @Environment(AppState.self) var appState
    var body: some View {
        RealityView { content in
            content.add(appState.root)
            for model in appState.activeSpace!.models {
                Task {
                    await getSticker(model: model)
                }
            }
        }
    }

    @MainActor
    func getSticker(model: StickerPose) async {
        do {
            let docRef = Firestore.firestore().collection("stickers").document(model.stickerId)
            let doc = try await docRef.getDocument()
            if doc.exists {
                if let entity = try await appState.addEntityToSpace(sticker: doc.data(as: Sticker.self)) {
                    print(entity.name)
                    entity.scenePosition = model.translation
                    entity.sceneOrientation = simd_quatf(real: model.rotation.real, imag: model.rotation.imag)
                    entity.scale = model.scale
                } else {
                    return
                }
            }
        } catch {
            return
        }
    }
}

// #Preview {
//    SpaceView(space: .init(name: "test", models: [StickerPose])).environment(AppState())
// }
