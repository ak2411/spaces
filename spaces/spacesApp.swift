//
//  spacesApp.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/10/24.
//

import SwiftUI
import FirebaseCore

// AppDelegate to initialize firebase
class AppDelegate : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
      }
}

@main
struct spacesApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    @StateObject var selectedVM = SelectedItemViewModel()
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .environmentObject(selectedVM)
                    .environment(appState)
                    .onChange(of: appState.phase.isImmersed) { _, showMRView in
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
        }
    }
}
