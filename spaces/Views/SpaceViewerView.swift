//
//  SpaceViewerView.swift
//  spaces
//
//  Created by Angelica Kosasih on 3/2/24.
//

import Foundation
import SwiftUI

struct SpaceViewerView: View {
    @StateObject var vm = SpacesListViewModel()
    @Environment(AppState.self) var appState
    var body: some View {
        Text("Select a space to view")
        Grid {
            ForEach(vm.spaces) { space in
                SpaceItemView(space: space)
            }
        }.onAppear {
            vm.listenToItems()
        }
    }
}

struct SpaceItemView: View {
    let space: StickerScene
    @Environment(AppState.self) var appState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some View {
        Button {
            appState.activeSpace = space
            appState.phase = .viewSpace
        } label: {
            Text(space.name)
        }
    }
}

#Preview {
    SpaceViewerView().environment(AppState())
}
