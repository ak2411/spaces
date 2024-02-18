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
    @StateObject var selectedVM = SelectedItemViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView().environmentObject(selectedVM)
            }
        }
        
        WindowGroup(id: "InstantiatedStickerItemView") {
            InstantiatedStickerItemView().environmentObject(selectedVM)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
    }
}
