//
//  SpaceEditorView.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import Foundation
import SwiftUI
import RealityKit

struct SpaceEditorView: View {
    @Environment var appState: AppState
    
    @Environment(\.dismiss) internal var dismiss
    
    var body: some View {
        RealityView { content in
            content.add(appState.root)
        }
        .onChange(of: appState.phase.isImmersed) { _, showMRView in
            if !showMRView {
                dismiss()
            }
        }
    }
}
