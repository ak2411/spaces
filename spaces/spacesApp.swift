//
//  spacesApp.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/10/24.
//

import FirebaseCore
import SwiftUI

// AppDelegate to initialize firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()

        return true
    }
}

@main
@MainActor
struct spacesApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    @State private var appState = AppState()
    @State private var style: ImmersionStyle = .full
    @StateObject var selectedVM = SelectedItemViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .environmentObject(selectedVM)
                    .environment(appState)
                    .onChange(of: appState.phase.isImmersed) { _, showMRView in
                        print("new state")
                        if showMRView {
                            Task {
                                await openImmersiveSpace(id: "SpaceEditor")
                            }
                        }
                    }
            }
        }

        WindowGroup(id: "InstantiatedStickerItemView") {
            InstantiatedStickerItemView().environmentObject(selectedVM)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)

        ImmersiveSpace(id: "SpaceEditor") {
            SpaceEditorView()
                .environment(appState)
        }
//        .immersionStyle(selection: $style, in: .full)
    }

    init() {
        EditableComponent.registerComponent()
    }
}
