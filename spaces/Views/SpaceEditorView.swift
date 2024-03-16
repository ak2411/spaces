//
//  SpaceEditorView.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import Foundation
import RealityKit
import SwiftUI

struct SpaceEditorView: View {
    @Environment(AppState.self) var appState

    @Environment(\.dismiss) var dismiss

    var body: some View {
        RealityView { content in
            content.add(appState.editRoot)
            /// FOR DEBUGGING PURPOSES
//            do {
//                guard let entity: Entity = try? await Entity(named: "toy_car") else {
//                    print("can't find model")
//                    return
//                }
//
//                // want a unique id for the specific sticker model
//                entity.name = "toy_car"
//                entity.generateCollisionShapes(recursive: true)
//                // needed for gesture stuff
//                entity.components.set(InputTargetComponent())
//                print("got entity")
//                content.add(entity)
//            }
        }
        .onChange(of: appState.phase) { _, phase in
            if phase != .editSpace {
                dismiss()
            }
        }
        /// FOR DEBUGGING PURPOSES
//        .onAppear {
//            appState.addEntityToSpace(sticker: .init(id: "test", name: "nn", usdzLink: "https://firebasestorage.googleapis.com/v0/b/avp-spaces.appspot.com/o/Earth.usdz?alt=media&token=803cbdb5-c13e-483c-98c7-38d2ff64dcd0"))
//        }
        .gesture(DragGesture(minimumDistance: 50)
            .targetedToAnyEntity()
            .onChanged { value in
                handleDrag(value, ended: false)
            }
            .onEnded { value in
                handleDrag(value, ended: true)
            }
        )
        .simultaneousGesture(RotateGesture(minimumAngleDelta: Angle(degrees: 4))
            .targetedToAnyEntity()
            .onChanged { value in
                handleRotation(value, ended: false)
            }
            .onEnded { value in
                handleRotation(value, ended: true)
            })
        .simultaneousGesture(MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                handleMagnify(value, ended: false)
            }
            .onEnded { value in
                handleMagnify(value, ended: true)
            }
        )
    }
}

#Preview {
    SpaceEditorView().environment(AppState())
}
