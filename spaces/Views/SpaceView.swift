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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        RealityView { content in
            content.add(appState.viewRoot)
        }.onChange(of: appState.phase) { _, phase in
            if phase != .viewSpace {
                dismiss()
            }
        }.onChange(of: appState.activeSpace) { _, _ in
            appState.updateStickersInSpace()
        }
    }
}
