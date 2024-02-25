//
//  HomeView.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/10/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct HomeView: View {
    @EnvironmentObject var selectedVM: SelectedItemViewModel
    @State private var createSpace = false
    @Environment(AppState.self) var appState

    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Welcome to Spaces")

                HStack {
                    NavigationLink {
                        StickerView().environmentObject(selectedVM)
                            .environment(appState)
                    } label: {
                        Text("Create a space")
                    }
            }
            
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    NavigationStack {
        HomeView()
    }
    
}
